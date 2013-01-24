////////////////////////////////////////////////////////////////////////////////
// Copyright 2013, Qualcomm Innovation Center, Inc.
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

////////////////////////////////////////////////////////////////////////////////
//
//  AJNBusControllerDelegate protocol
//
@protocol AJNBusControllerDelegate <NSObject>

@property (nonatomic, readonly) NSString *applicationName;
@property (nonatomic, readonly) NSString *serviceName;
@property (nonatomic, readonly) AJNBusNameFlag serviceNameFlags;
@property (nonatomic, readonly) AJNSessionPort sessionPort;

@optional

- (void)didStartBus:(AJNBusAttachment *)bus;
- (void)didConnectBus:(AJNBusAttachment *)bus;

- (void)listenerDidRegisterWithBus:(AJNBusAttachment *)busAttachment;
- (void)listenerDidUnregisterWithBus:(AJNBusAttachment *)busAttachment;
- (void)didFindAdvertisedName:(NSString *)name withTransportMask:(AJNTransportMask) transport namePrefix:(NSString *)namePrefix;
- (void)didLoseAdvertisedName:(NSString *)name withTransportMask:(AJNTransportMask) transport namePrefix:(NSString *)namePrefix;
- (void)nameOwnerChanged:(NSString *)name to:(NSString *)newOwner from:(NSString *)previousOwner;
- (void)busWillStop;
- (void)busDidDisconnect;

- (void)sessionWasLost:(AJNSessionId)sessionId;
- (void)didAddMemberNamed:(NSString *)memberName toSession:(AJNSessionId)sessionId;
- (void)didRemoveMemberNamed:(NSString *)memberName fromSession:(AJNSessionId)sessionId;

- (void)didReceiveStatusMessage:(NSString *)message;

@end
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
//  AJNBusController protocol
//
@protocol AJNBusController <AJNBusListener, AJNSessionListener>

// Bus Attachment
//
@property (nonatomic, strong) AJNBusAttachment *bus;

// Session Options
//
@property (nonatomic) BOOL allowRemoteMessages;
@property (nonatomic) AJNTrafficType trafficType;
@property (nonatomic) AJNProximity proximityOptions;
@property (nonatomic) AJNTransportMask transportMask;
@property (nonatomic) BOOL multiPointSessionsEnabled;
@property (nonatomic, readonly) AJNSessionId sessionId;

// Connection options
//
@property (nonatomic, strong) NSString *connectionArguments;

// Initialization
//
- (id)init;
- (id)initWithBusAttachment:(AJNBusAttachment *)busAttachment;

// Bus Control
//
- (void)start;

- (void)stop;

@end
////////////////////////////////////////////////////////////////////////////////
