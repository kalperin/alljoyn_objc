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

#import <Foundation/Foundation.h>
#import "AJNSessionOptions.h"

////////////////////////////////////////////////////////////////////////////////
//
// A simple delegate for the PingService
//
@protocol PingServiceDelegate <NSObject>

// transport mask to use for network communication
//
@property (nonatomic, readonly) AJNTransportMask transportType;

// The delegate is called once a client joins a session with the service
//
- (void)client:(NSString *)clientName didJoinSession:(AJNSessionId)sessionId;

// The delegate is called when a client leaves a session
//
- (void)client:(NSString *)clientName didLeaveSession:(AJNSessionId)sessionId;

// Send updates on internal state of Ping Service
//
- (void)receivedStatusMessage:(NSString*)message;

@end
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// A simple AllJoyn service that exposes a ping object
//
@interface PingService : NSObject

@property (nonatomic, strong) id<PingServiceDelegate> delegate;

- (id)initWithDelegate:(id<PingServiceDelegate>)delegate;

- (void)start:(NSString *)serviceName;
- (void)stop;

+ (PingService *)sharedInstance;

@end
////////////////////////////////////////////////////////////////////////////////
