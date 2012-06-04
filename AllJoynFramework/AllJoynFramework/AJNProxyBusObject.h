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
#import "AJNObject.h"
#import "AJNSessionOptions.h"
#import "AJNStatus.h"

@class AJNBusAttachment;
@class AJNInterfaceDescription;
@class AJNInterfaceMember;
@class AJNMessage;
@class AJNMessageArgument;
@class AJNProxyBusObject;

@protocol AJNProxyBusObjectDelegate <NSObject>

@optional

- (void)didCompleteIntrospectionOfObject:(AJNProxyBusObject*)object context:(AJNHandle)context withStatus:(QStatus)status;

- (void)didReceiveMethodReply:(AJNMessage*)replyMessage context:(AJNHandle)context;

@end

@interface AJNProxyBusObject : AJNObject

@property (nonatomic, readonly) NSString *path;
@property (nonatomic, readonly) NSString *serviceName;
@property (nonatomic, readonly) AJNSessionId sessionId;
@property (nonatomic, readonly) NSArray *interfaces;
@property (nonatomic, readonly) NSArray *children;
@property (nonatomic, readonly) BOOL isValid;

- (id)initWithBusAttachment:(AJNBusAttachment*)busAttachment serviceName:(NSString*)serviceName objectPath:(NSString*)path sessionId:(AJNSessionId)sessionId;

- (QStatus)addInterfaceNamed:(NSString*)interfaceName;
- (QStatus)addInterfaceFromDescription:(AJNInterfaceDescription*)interfaceDescription;
- (AJNInterfaceDescription*)interfaceWithName:(NSString*)name;
- (BOOL)implementsInterfaceWithName:(NSString*)name;

- (AJNProxyBusObject*)childAtPath:(NSString*)path;
- (QStatus)addChild:(AJNProxyBusObject*)child;
- (QStatus)removeChildAtPath:(NSString*)path;

- (QStatus)callMethod:(AJNInterfaceMember*)method withArguments:(NSArray*)arguments methodReply:(AJNMessage**)reply;
- (QStatus)callMethod:(AJNInterfaceMember*)method withArguments:(NSArray*)arguments methodReply:(AJNMessage**)reply timeout:(NSInteger)timeout flags:(uint8_t)flags;
- (QStatus)callMethodAsync:(AJNInterfaceMember*)method withArguments:(NSArray*)arguments methodReplyDelegate:(id<AJNProxyBusObjectDelegate>)replyDelegate context:(AJNHandle)context timeout:(NSInteger)timeout flags:(uint8_t)flags;
- (QStatus)callMethodWithName:(NSString*)methodName onInterfaceWithName:(NSString*)interfaceName withArguments:(NSArray*)arguments methodReply:(AJNMessage**)reply;
- (QStatus)callMethodWithName:(NSString*)methodName onInterfaceWithName:(NSString*)interfaceName withArguments:(NSArray*)arguments methodReply:(AJNMessage**)reply timeout:(NSInteger)timeout flags:(uint8_t)flags;
- (QStatus)callMethodWithNameAsync:(NSString*)methodName onInterfaceWithName:(NSString*)interfaceName withArguments:(NSArray*)arguments methodReplyDelegate:(id<AJNProxyBusObjectDelegate>)replyDelegate context:(AJNHandle)context timeout:(NSInteger)timeout flags:(uint8_t)flags;

- (QStatus)introspectRemoteObject;
- (QStatus)introspectRemoteObjectAsync:(id<AJNProxyBusObjectDelegate>)completionHandler context:(AJNHandle)context;
- (QStatus)buildFromXml:(NSString*)xmlProxyObjectDescription errorLogId:(NSString*)identifier;

- (AJNMessageArgument*)propertyWithName:(NSString*)propertyName forInterfaceWithName:(NSString*)interfaceName;
- (QStatus)propertyValues:(AJNMessageArgument**)values ofInterfaceWithName:(NSString*)interfaceName;
- (QStatus)setPropertyWithName:(NSString*)propertyName forInterfaceWithName:(NSString*)interfaceName toValue:(AJNMessageArgument*)value;
- (QStatus)setPropertyWithName:(NSString*)propertyName forInterfaceWithName:(NSString*)interfaceName toIntValue:(NSInteger)value;
- (QStatus)setPropertyWithName:(NSString*)propertyName forInterfaceWithName:(NSString*)interfaceName toStringValue:(NSString*)value;

- (QStatus)secureConnection:(BOOL)forceAuthentication;
- (QStatus)secureConnectionAsync:(BOOL)forceAuthentication;

@end
