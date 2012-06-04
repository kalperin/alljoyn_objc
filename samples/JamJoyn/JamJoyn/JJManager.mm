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

#import "JJManager.h"
#import "JJConstants.h"
#import "JJService.h"
#import <alljoyn/BusAttachment.h>

struct JJSong
{
    int32_t songId;
    qcc::String songPath;
    qcc::String songName;
    qcc::String artist;
    qcc::String album;
    int32_t albumId;
    qcc::String artPath;
    qcc::String fileName;
    qcc::String busId;    
};


static JJManager *s_manager;

@interface AJNBusAttachment(Private)

@property (nonatomic, readonly) ajn::BusAttachment *busAttachment;

@end

@interface JJManager()<AJNBusListener, AJNSessionListener, AJNSessionPortListener, JamJoynServiceDelegate> {
    JJSong *currentPlaylist;
    NSInteger playlistSongCount;
}

@property (nonatomic, strong) NSMutableArray *theRooms;
@property (nonatomic, strong) JamJoynServiceObjectProxy *jamjoynService;
@property (nonatomic, strong) AJNJamJoynServiceObject *serviceObject;
@property (nonatomic) AJNSessionId sessionId;
@property (nonatomic) BOOL isPlaying;

@property (nonatomic, strong) AJNBusAttachment *bus;

@end

@implementation JJManager

@synthesize theRooms = _theRooms;
@synthesize sessionId = _sessionId;
@synthesize delegate = _delegate;

@synthesize bus = _bus;
@synthesize jamjoynService = _jamjoynService;
@synthesize serviceObject = _serviceObject;
@synthesize handle = _handle;
@synthesize currentRoom = _currentRoom;
@synthesize currentSong = _currentSong;
@synthesize isPlaying = _isPlaying;

- (NSArray *)rooms
{
    return [self.theRooms copy];
}

- (JJSong *)playlist
{
    return currentPlaylist;
}

- (NSInteger)playlistSongCount
{
    return playlistSongCount;
}

- (NSMutableArray *)theRooms
{
    if (_theRooms == nil) {
        _theRooms = [[NSMutableArray alloc] init];
    }
    return _theRooms;
}

- (void)setCurrentRoom:(NSInteger)currentRoom
{
    _currentRoom = currentRoom;
    [self joinRoom:currentRoom];
}

- (id) init
{
    self = [super init];
    if (self) {

        self.bus = [[AJNBusAttachment alloc] initWithApplicationName:kAppName allowingRemoteMessages:YES];
        
        [self.bus registerBusListener:self];
        
        [self.bus createInterfacesFromXml:kXMLInterfaceDescription];

        // start the bus and begin listening for bus traffic
        //
        [self.bus start];
        
        [self.bus connectWithArguments:@"null:"];
        
        // register signal handler
        //
        [self.bus registerJamJoynServiceObjectSignalHandler:self];
        
        self.serviceObject = [[AJNJamJoynServiceObject alloc] initWithBusAttachment:self.bus onPath:kServicePath];
        
        [self.bus registerBusObject:self.serviceObject];
        
        [self.bus findAdvertisedName:@"org.alljoyn.bus.samples.commandpasser"];    
        
   }
    return self;
}

- (void)joinRoom:(NSInteger)roomIndex
{
    NSString *room = [self.theRooms objectAtIndex:roomIndex];
    
    AJNSessionOptions *sessionOptions = [[AJNSessionOptions alloc] initWithTrafficType:kAJNTrafficMessages supportsMultipoint:YES proximity:kAJNProximityAny transportMask:kAJNTransportMaskAny];
    
    self.sessionId = [self.bus joinSessionWithName:room onPort:kServicePort withDelegate:self options:sessionOptions];
    
    [self.serviceObject announceNickName:@"iOS_R0x0r" isHost:NO inSession:self.sessionId toDestination:nil];
    
    self.jamjoynService = [[JamJoynServiceObjectProxy alloc] initWithBusAttachment:self.bus serviceName:room objectPath:kServicePath sessionId:self.sessionId];
    
}

- (void)play
{
    JJSong *song = self.playlist + self.currentSong;
    NSString *argument;
    if (!self.isPlaying) {
        argument = [NSString stringWithFormat:@"%s|-|%s", song->songName.c_str(), song->album.c_str()];
    }
    [self.jamjoynService sendCommand:@"playSong" argument:argument];
}

- (void)stop
{
    [self.jamjoynService sendCommand:@"stopSong" argument:nil];    
    self.isPlaying = FALSE;
}

- (void)pause
{
    [self.jamjoynService sendCommand:@"pauseSong" argument:nil];        
}

#pragma mark - AJNBusListener delegate methods

- (void)didFindAdvertisedName:(NSString *)name withTransportMask:(AJNTransportMask)transport namePrefix:(NSString *)namePrefix
{
    NSLog(@"JJManager::didFindAdvertisedName:%@ withTransportMask:%i namePrefix:%@", name, transport, namePrefix);
    
    NSString *jjSessionName = [NSString stringWithFormat:@"%@", [[name componentsSeparatedByString:@"."] objectAtIndex:5]];
    
    NSLog(@"Discovered JamJoyn session: \"%@\"\n", jjSessionName);
    
    @synchronized(self.theRooms) {
        if (![self.theRooms containsObject:name]) {
            NSLog(@"JamJoyn session for %@ not found. Adding to dictionary...", jjSessionName);
            
            [self.theRooms addObject:name];
        }
        
    }
    
    [self.delegate roomsChanged];
    
//    
//    if ([self.delegate respondsToSelector:@selector(didUpdateConversations)]) {
//        [self.delegate didUpdateConversations];
//    }    
}

- (void)didLoseAdvertisedName:(NSString*)name withTransportMask:(AJNTransportMask)transport namePrefix:(NSString*)namePrefix
{
    NSLog(@"JJManager::didLoseAdvertisedName:%@ withTransportMask:%i namePrefix:%@", name, transport, namePrefix);
    
    [self.delegate roomsChanged];
    
//    NSString *conversationName = [NSString stringWithFormat:@"%@", [[name componentsSeparatedByString:@"."] lastObject]];
//    
//    NSLog(@"Lost chat conversation: \"%@\"\n", conversationName);
//    
//    @synchronized(self.conversationNames) {
//        if ([self.conversationNames containsObject:conversationName]) {
//            NSLog(@"Chat session for conversation %@ not found. Adding to dictionary...", conversationName);
//            
//            [self.conversationNames removeObject:conversationName];
//        }
//        
//        AJNCConversation *conversation = [self.nameToConversationTable objectForKey:conversationName];
//        if (conversation) {
//            [self.nameToConversationTable removeObjectForKey:conversationName];
//            [self.busAttachment unregisterBusObject:conversation.chatObject];
//        }
//    }
//    
//    if ([self.delegate respondsToSelector:@selector(didUpdateConversations)]) {
//        [self.delegate didUpdateConversations];
//    }
}

- (void)nameOwnerChanged:(NSString *)name to:(NSString *)newOwner from:(NSString *)previousOwner
{
    NSLog(@"JJManager::nameOwnerChanged:%@ to:%@ namePrefix:%@", name, newOwner, previousOwner);    
}

#pragma mark - AJNSessionPortListener delegate methods

- (void)didJoin:(NSString *)joiner inSessionWithId:(AJNSessionId)sessionId onSessionPort:(AJNSessionPort)sessionPort
{
    NSLog(@"JJManager::didJoin:%@ inSessionWithId:%u onSessionPort:%u", joiner, sessionId, sessionPort);    
}

- (BOOL)shouldAcceptSessionJoinerNamed:(NSString *)joiner onSessionPort:(AJNSessionPort)sessionPort withSessionOptions:(AJNSessionOptions *)options
{
    NSLog(@"JJManager::shouldAcceptSessionJoinerNamed:%@ onSessionPort:%u", joiner, sessionPort);        
    return sessionPort == kServicePort;
}

#pragma mark - AJNSessionListener delegate methods

- (void)sessionWasLost:(AJNSessionId)sessionId
{
    NSLog(@"JJManager::sessionWasLost:%u", sessionId);            
}

- (void)didAddMemberNamed:(NSString*)memberName toSession:(AJNSessionId)sessionId
{
    NSLog(@"JJManager::didAddMemberNamed:%@ toSession:%u", memberName, sessionId);  
//    for (AJNCConversation *conversation in self.nameToConversationTable.allValues) {
//        if (conversation.identifier == sessionId) {
//            conversation.totalParticipants += 1;
//        }
//    }
}

- (void)didRemoveMemberNamed:(NSString*)memberName fromSession:(AJNSessionId)sessionId
{
    NSLog(@"JJManager::didRemoveMemberNamed:%@ fromSession:%u", memberName, sessionId);                    
//    for (AJNCConversation *conversation in self.nameToConversationTable.allValues) {
//        if (conversation.identifier == sessionId) {
//            conversation.totalParticipants -= 1;
//        }
//    }
}

#pragma mark - JamJoynServiceDelegate

- (void)receiveSongList:(JJSong *)songs size:(long)songCount
{
//    JJSong *song = songs;
//    NSLog(@"Song: %s %s", song->songName.c_str(), song->album.c_str());
//    song = songs + 1;
//    NSLog(@"Song: %s %s", song->songName.c_str(), song->album.c_str());
//    song = songs + 2;
//    NSLog(@"Song: %s %s", song->songName.c_str(), song->album.c_str());

    currentPlaylist = songs;
    playlistSongCount = songCount;
    
    [self.delegate playListReceived];
}

- (void)announcementReceived
{
    [self.jamjoynService sendCommand:@"setPlayList" argument:nil];        
}

- (void)receivedCommand:(NSString *)command withArguments:(NSString *)arguments
{
    if ([command compare:@"changePlayPauseStatus"] == NSOrderedSame) {
        if ([arguments compare:@"play"] == NSOrderedSame) {
            self.isPlaying = false;
            NSLog(@"Play state set to FALSE");
        }
        else if ([arguments compare:@"pause"] == NSOrderedSame) {
            self.isPlaying = true;
            NSLog(@"Play state set to TRUE");
        }
    }
}

#pragma mark - Class methods

+ (void)initialize
{
    @synchronized(self) {
        if (s_manager == nil) {
            s_manager = [[JJManager alloc] init];
        }
    }
}

+ (JJManager*)sharedInstance
{
    @synchronized(self) {
        return s_manager;
    }
}


@end
