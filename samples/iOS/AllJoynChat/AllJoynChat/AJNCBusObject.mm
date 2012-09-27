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

#import "AJNCBusObject.h"
#import "AJNCConversation.h"
#import "AJNCConstants.h"
#import "AJNBusAttachment.h"
#import "AJNCBusObjectImpl.h"
#import "AJNCMessage.h"
#import "AJNInterfaceDescription.h"

@interface AJNCBusObject()

@property (nonatomic) NSInteger sessionType;

@end

@implementation AJNCBusObject

@synthesize session = _session;
@synthesize sessionType = _sessionType;
@synthesize delegate = _delegate;

- (id)initWithBusAttachment:(AJNBusAttachment *)busAttachment onServicePath:(NSString *)path
{
    self = [super initWithBusAttachment:busAttachment onPath:path];
    if (self) {
        // create the internal C++ bus object
        //
        AJNCBusObjectImpl *busObject = new AJNCBusObjectImpl(*((ajn::BusAttachment*)busAttachment.handle), [path UTF8String], self);
        
        self.handle = busObject;
    }
    
    return self;
}

- (void)sendChatMessage:(NSString*)message onSession:(AJNSessionId)sessionId
{
    QStatus status = static_cast<AJNCBusObjectImpl*>(self.handle)->SendChatSignal([message UTF8String], sessionId);
    if (status != ER_OK) {
        NSLog(@"ERROR: sendChatMessage failed. %@", [AJNStatus descriptionForStatusCode:status]);
    }
}

- (void)chatMessageReceived:(NSString *)message from:(NSString*)sender onObjectPath:(NSString *)path forSession:(AJNSessionId)sessionId
{
    if (self.session.identifier != sessionId) {
        return;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    
    AJNCMessage *chatMessage = [[AJNCMessage alloc] initWithText:message fromSender:sender atDateTime:[formatter stringFromDate:[NSDate date]]];
    [self.session.messages addObject:chatMessage];

    [self.delegate chatMessageReceived:message from:sender onObjectPath:path forSession:sessionId];
}

@end
