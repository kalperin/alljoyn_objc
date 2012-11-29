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

#import "AJNBusAttachment.h"

// A simple delegate for the PingClient
//
@protocol PingClientDelegate <NSObject>

@property (nonatomic, readonly) AJNTransportMask transportType;

// The delegate is called once a connection is established between the client
// and the service
//
- (void)didConnectWithService:(NSString *)serviceName;

// The delegate is called when a service session is lost
//
- (void)shouldDisconnectFromService:(NSString *)serviceName;

// Send updates on internal state of Ping Client
//
- (void)receivedStatusMessage:(NSString*)message;

@end

// A simple AllJoyn client
//
@interface PingClient : NSObject

@property (nonatomic, strong) id<PingClientDelegate> delegate;

- (id)initWithDelegate:(id<PingClientDelegate>)delegate;

- (void)connectToService:(NSString *)serviceName;
- (void)disconnect;

- (NSString *)sendPingToService:(NSString *)str1;

+ (PingClient *)sharedInstance;

@end
