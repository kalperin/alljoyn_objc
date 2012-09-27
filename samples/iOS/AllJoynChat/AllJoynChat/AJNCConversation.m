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

#import "AJNCConversation.h"
#import "AJNCConstants.h"
#import "AJNCMessage.h"

@interface AJNCConversation()


@end

@implementation AJNCConversation

@synthesize name = _name;
@synthesize identifier = _identifier;
@synthesize chatObject = _chatObject;
@synthesize messages = _messages;
@synthesize type = _type;
@synthesize totalParticipants = _totalParticipants;

- (NSMutableArray*)messages
{
    if (_messages == nil) {
        _messages = [[NSMutableArray alloc] init];
    }
    return _messages;
}

- (NSString*)displayName
{
    return [[self.name componentsSeparatedByString:@"."] lastObject];
}

- (id)initWithName:(NSString*)name identifier:(AJNSessionId)sessionId busObject:(AJNCBusObject *)chatObject
{
    self = [super init];
    if (self) {
        self.name = name;
        self.identifier = sessionId;
        self.chatObject = chatObject;
        self.chatObject.session = self;
        self.type = kAJNCConversationTypeRemoteHost;
    }
    return self;
}

- (void)chatMessageReceived:(NSString *)message from:(NSString *)sender onObjectPath:(NSString *)path forSession:(AJNSessionId)sessionId
{
    if (self.identifier != sessionId) {
        return;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    
    AJNCMessage *chatMessage = [[AJNCMessage alloc] initWithText:message fromSender:sender atDateTime:[formatter stringFromDate:[NSDate date]]];
    [self.messages addObject:chatMessage];
}

@end
