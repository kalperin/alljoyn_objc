////////////////////////////////////////////////////////////////////////////////
// Copyright 2012, Qualcomm Innovation Center, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
////////////////////////////////////////////////////////////////////////////////

#import <AVFoundation/AVFoundation.h>

#import "AJNCBusObject.h"
#import "AJNCChatManager.h"
#import "AJNCConversation.h"
#import "AJNCChatObjectSignalHandler.h"
#import "AJNCMessage.h"

#import "AJNBusAttachment.h"
#import "AJNBusListener.h"
#import "AJNCConstants.h"
#import "AJNInterfaceDescription.h"
#import "AJNSessionListener.h"
#import "AJNSessionPortListener.h"

static AJNCChatManager *s_chatManager;

@interface AJNCChatManager()<AJNBusListener, AJNSessionListener, AJNSessionPortListener, AVAudioPlayerDelegate>

@property (nonatomic, strong) AJNBusAttachment *busAttachment;
@property (nonatomic, strong) NSMutableArray *conversationNames;
@property (nonatomic, strong) NSMutableDictionary *nameToConversationTable;
@property (nonatomic, strong) AJNCChatObjectSignalHandler *chatObjectSignalHandler;
@property (nonatomic, strong) NSMutableArray *audioPlayers;
@property BOOL isStarted;

- (void)playNewMessageSound;

@end

@implementation AJNCChatManager

@synthesize delegate = _delegate;
@synthesize busAttachment = _busAttachment;
@synthesize conversationNames = _conversationNames;
@synthesize nameToConversationTable = _nameToConversationTable;
@synthesize chatObjectSignalHandler = _chatObjectSignalHandler;
@synthesize audioPlayers = _audioPlayers;
@synthesize isStarted = _isStarted;

- (NSMutableArray*)conversationNames
{
    if (_conversationNames == nil) {
        _conversationNames = [[NSMutableArray alloc] init];
    }
    return _conversationNames;
}

- (NSMutableDictionary*)nameToConversationTable
{
    if (_nameToConversationTable == nil) {
        _nameToConversationTable = [[NSMutableDictionary alloc] init];
    }
    return _nameToConversationTable;
}

- (NSMutableArray*)audioPlayers
{
    if (_audioPlayers == nil) {
        _audioPlayers = [[NSMutableArray alloc] init];
    }
    return _audioPlayers;
}

- (void)start
{
    if (self.isStarted) {
        NSLog(@"Already started");
        return;
    }
    // allocate our bus attachment
    //
    self.busAttachment = [[AJNBusAttachment alloc] initWithApplicationName:kAppName allowRemoteMessages:YES];
    
    // create and register our interface
    //
    AJNInterfaceDescription* chatInterface = [self.busAttachment createInterfaceWithName:kInterfaceName enableSecurity:NO];
    
    [chatInterface addSignalWithName:@"Chat" inputSignature:@"s" argumentNames:[NSArray arrayWithObject:@"str"]];
    
    [chatInterface activate];
    
    // register signal handler
    //
    self.chatObjectSignalHandler = [[AJNCChatObjectSignalHandler alloc] init];
    self.chatObjectSignalHandler.delegate = self;
    [self.busAttachment registerSignalHandler:self.chatObjectSignalHandler];
    
    // start the bus and begin listening for bus traffic
    //
    [self.busAttachment start];
    
    [self.busAttachment registerBusListener:self];
    
    [self.busAttachment connectWithArguments:@"null:"];   
    
    [self.busAttachment findAdvertisedName:kInterfaceName];    
    
    AJNSessionOptions *sessionOptions = [[AJNSessionOptions alloc] initWithTrafficType:kAJNTrafficMessages supportsMultipoint:YES proximity:kAJNProximityAny transportMask:kAJNTransportMaskAny];
    
    QStatus status = [self.busAttachment bindSessionOnPort:kServicePort withOptions:sessionOptions withDelegate:self];
    if (status != ER_OK) {
        NSLog(@"ERROR: addConversationNamed: failed. %@", [AJNStatus descriptionForStatusCode:status]);
    }
    
    self.isStarted = YES;
}

- (void)stop
{
    if (!self.isStarted) {
        return;
    }
    
    [self.busAttachment unbindSessionFromPort:kServicePort];
    
    [self.busAttachment cancelFindAdvertisedName:kInterfaceName];
    
    [self.busAttachment disconnectWithArguments:@"null:"];
    
    [self.busAttachment unregisterBusListener:self];
    
    [self.busAttachment stop];
    
    self.busAttachment = nil;
    
    self.isStarted = NO;
}

- (BOOL)addConversationNamed:(NSString*)conversationName
{
    NSString *serviceName = [NSString stringWithFormat:@"%@%@", kServiceName, conversationName];
    
    // request the service name for the sample object
    //
    QStatus status = [self.busAttachment requestWellKnownName:serviceName withFlags:kAJNBusNameFlagReplaceExisting|kAJNBusNameFlagDoNotQueue];
    
    // advertise a name and let others connect to our service
    //
    status = [self.busAttachment advertiseName:serviceName withTransportMask:kAJNTransportMaskAny];

    return status == ER_OK;
}

- (void)joinConversation:(AJNCConversation*)conversation
{
    if (conversation && conversation.identifier == 0) {
        NSLog(@"Joining conversation %@ with session named: %@", conversation.displayName, conversation.name);
        /* Join the conversation */
        AJNSessionOptions *sessionOptions = [[AJNSessionOptions alloc] initWithTrafficType:kAJNTrafficMessages supportsMultipoint:YES proximity:kAJNProximityAny transportMask:kAJNTransportMaskAny];
        
        conversation.identifier = [self.busAttachment joinSessionWithName:conversation.name onPort:kServicePort withDelegate:self options:sessionOptions];
        
        NSLog(@"Joined conversation %@ with session named: %@ (%u)", conversation.displayName, conversation.name, conversation.identifier);
    }
}

- (void)leaveConversation:(AJNCConversation *)conversation
{
    NSLog(@"Leaving conversation %@ with session named: %@", conversation.displayName, conversation.name);
    
    [self.busAttachment leaveSession:conversation.identifier];
    
    @synchronized(self.conversationNames) {
        if ([self.conversationNames containsObject:conversation.name]) {
            NSLog(@"Chat session for conversation %@ found. Removing from array...", conversation.name);
            
            [self.conversationNames removeObject:conversation.name];
        }
        
        if ([self.nameToConversationTable objectForKey:conversation.name]) {
            NSLog(@"Chat session for conversation %@ found. Removing from dictionary...", conversation.name);            
            [self.nameToConversationTable removeObjectForKey:conversation.name];
            [self.busAttachment unregisterBusObject:conversation.chatObject];
        }
    }
    
}

- (BOOL)sendMessage:(NSString*)message inConversation:(NSString*)conversationName
{
    return NO;
}

- (NSInteger)conversationsCount
{
    @synchronized(self.conversationNames) {
        return self.conversationNames.count;
    }
}

- (AJNCConversation*)conversationAtIndex:(NSInteger)index
{
    @synchronized(self.conversationNames) {
        return [self.nameToConversationTable objectForKey:[self.conversationNames objectAtIndex:index]];
    }
}

- (void)chatMessageReceived:(NSString *)message from:(NSString *)sender onObjectPath:(NSString *)path forSession:(AJNSessionId)sessionId
{
    NSLog(@"Chat message [%@] from [%@] received in ChatManager session %d. Conversations count=%d", message, sender, sessionId, self.conversationsCount);
    
    if (self.conversationsCount) {
        AJNCConversation *conversation = [self conversationAtIndex:0];
        NSString *senderUIName;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeStyle:NSDateFormatterMediumStyle];
        [formatter setDateStyle:NSDateFormatterShortStyle];            
        
        if ([sender compare:@"Me"] != NSOrderedSame) {
            senderUIName = [NSString stringWithFormat:@"User[%@]", sender];
        }
        else {
            senderUIName = sender;
        }
        
        AJNCMessage *conversationMessage = [[AJNCMessage alloc] initWithText:message fromSender:senderUIName atDateTime:[formatter stringFromDate:[NSDate date]]];
        [conversation.messages addObject:conversationMessage];
        if ([self.delegate respondsToSelector:@selector(didReceiveNewMessage:)]) {
            [self.delegate didReceiveNewMessage:conversationMessage];
        }
        [self playNewMessageSound];
    }
}

#pragma mark - AJNBusListener delegate methods

- (void)didFindAdvertisedName:(NSString *)name withTransportMask:(AJNTransportMask)transport namePrefix:(NSString *)namePrefix
{
    NSLog(@"AJNCChatSessionsViewController::didFindAdvertisedName:%@ withTransportMask:%i namePrefix:%@", name, transport, namePrefix);
    
    NSString *conversationName = [NSString stringWithFormat:@"%@", [[name componentsSeparatedByString:@"."] lastObject]];
    
    NSLog(@"Discovered chat conversation: \"%@\"\n", conversationName);
    
    [self.busAttachment enableConcurrentCallbacks];
    
    @synchronized(self.conversationNames) {
        if (![self.conversationNames containsObject:conversationName]) {
            NSLog(@"Chat session for conversation %@ not found. Adding to dictionary...", conversationName);

            [self.conversationNames addObject:conversationName];
            
            AJNCBusObject *chatObject = [[AJNCBusObject alloc] initWithBusAttachment:self.busAttachment onServicePath:kServicePath];
            
            [self.busAttachment registerBusObject:chatObject];
            
            AJNCConversation *conversation = [[AJNCConversation alloc] initWithName:name identifier:0 busObject:chatObject];
            
            [self.nameToConversationTable setObject:conversation forKey:conversationName];
            
            [self joinConversation:conversation];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(didUpdateConversations)]) {
        [self.delegate didUpdateConversations];
    }    
}

- (void)didLoseAdvertisedName:(NSString*)name withTransportMask:(AJNTransportMask)transport namePrefix:(NSString*)namePrefix
{
    NSLog(@"AJNCChatManager::didLoseAdvertisedName:%@ withTransportMask:%i namePrefix:%@", name, transport, namePrefix);
    
    NSString *conversationName = [NSString stringWithFormat:@"%@", [[name componentsSeparatedByString:@"."] lastObject]];
    
    NSLog(@"Lost chat conversation: \"%@\"\n", conversationName);
    
    @synchronized(self.conversationNames) {
        if ([self.conversationNames containsObject:conversationName]) {
            NSLog(@"Chat session for conversation %@ found. Removing from dictionary...", conversationName);
            
            [self.conversationNames removeObject:conversationName];
        }
        
        AJNCConversation *conversation = [self.nameToConversationTable objectForKey:conversationName];
        if (conversation) {
            [self.nameToConversationTable removeObjectForKey:conversationName];
            [self.busAttachment unregisterBusObject:conversation.chatObject];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(didUpdateConversations)]) {
        [self.delegate didUpdateConversations];
    }
}

- (void)nameOwnerChanged:(NSString *)name to:(NSString *)newOwner from:(NSString *)previousOwner
{
    NSLog(@"AJNCChatManager::nameOwnerChanged:%@ to:%@ namePrefix:%@", name, newOwner, previousOwner);    
}

#pragma mark - AJNSessionPortListener delegate methods

- (void)didJoin:(NSString *)joiner inSessionWithId:(AJNSessionId)sessionId onSessionPort:(AJNSessionPort)sessionPort
{
    NSLog(@"AJNCChatManager::didJoin:%@ inSessionWithId:%u onSessionPort:%u", joiner, sessionId, sessionPort);    
    
    if (self.conversationsCount) {
        AJNCConversation *conversation = [self conversationAtIndex:0];
        if (conversation.identifier <= 0) {
            conversation.identifier = sessionId;
        }
    }

}

- (BOOL)shouldAcceptSessionJoinerNamed:(NSString *)joiner onSessionPort:(AJNSessionPort)sessionPort withSessionOptions:(AJNSessionOptions *)options
{
    NSLog(@"AJNCChatManager::shouldAcceptSessionJoinerNamed:%@ onSessionPort:%u", joiner, sessionPort);
    return sessionPort == kServicePort;
}

#pragma mark - AJNSessionListener delegate methods

- (void)sessionWasLost:(AJNSessionId)sessionId
{
    NSLog(@"AJNCChatManager::sessionWasLost:%u", sessionId);            
}

- (void)didAddMemberNamed:(NSString*)memberName toSession:(AJNSessionId)sessionId
{
    NSLog(@"AJNCChatManager::didAddMemberNamed:%@ toSession:%u", memberName, sessionId);  
    for (AJNCConversation *conversation in self.nameToConversationTable.allValues) {
        if (conversation.identifier == 0) {
            conversation.identifier = sessionId;
        }
        if (conversation.identifier == sessionId) {
            conversation.totalParticipants += 1;
        }
    }
}

- (void)didRemoveMemberNamed:(NSString*)memberName fromSession:(AJNSessionId)sessionId
{
    NSLog(@"AJNCChatManager::didRemoveMemberNamed:%@ fromSession:%u", memberName, sessionId);                    
    for (AJNCConversation *conversation in self.nameToConversationTable.allValues) {
        if (conversation.identifier == sessionId) {
            conversation.totalParticipants -= 1;
        }
    }
}

#pragma mark - Audio Implementation methods

- (void)playNewMessageSound
{
    NSString *audioFilePath = [[NSBundle mainBundle] pathForResource:@"Submarine" ofType:@"aiff"];
    if (audioFilePath) {
        AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:audioFilePath] error:nil];
        player.volume = 1.0;
        [player play];
        [self.audioPlayers addObject:player];
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self.audioPlayers removeObject:player];
}

-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    NSLog(@"ERROR: Ooops! Audio decoder error occurred. %@",error);
    [self.audioPlayers  removeObject:player];
}

#pragma mark - Class methods

+ (void)initialize
{
    @synchronized(self) {
        if (s_chatManager == nil) {
            s_chatManager = [[AJNCChatManager alloc] init];
        }
    }
}

+ (AJNCChatManager*)sharedInstance
{
    @synchronized(self) {
        return s_chatManager;
    }
}

@end
