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

#import "AJNAuthenticationListener.h"
#import "AJNBus.h"
#import "AJNBusListener.h"
#import "AJNKeyStoreListener.h"
#import "AJNObject.h"
#import "AJNSessionListener.h"
#import "AJNSessionOptions.h"
#import "AJNSessionPortListener.h"
#import "AJNSignalHandler.h"
#import "AJNStatus.h"

@protocol AJNBusObject;

@class AJNBusObject;
@class AJNProxyBusObject;
@class AJNInterfaceDescription;
@class AJNInterfaceMember;

typedef void(^AJNJoinSessionBlock)(QStatus status, AJNSessionId sessionId, AJNSessionOptions *opts, void *context);

@protocol AJNSessionDelegate <NSObject>

- (void)didJoinSession:(AJNSessionId)sessionId status:(QStatus)status sessionOptions:(AJNSessionOptions*)sessionOptions context:(AJNHandle)context;

@end

@interface AJNBusAttachment : AJNObject

@property (nonatomic, readonly) BOOL isConnected;
@property (nonatomic, readonly) BOOL isStarted;
@property (nonatomic, readonly) BOOL isStopping;
@property (nonatomic, readonly) NSString *uniqueName;
@property (nonatomic, readonly) NSString *uniqueIdentifier;
@property (nonatomic, readonly) BOOL isPeerSecurityEnabled;
@property (nonatomic, readonly) uint32_t concurrency;
@property (nonatomic, readonly) AJNProxyBusObject *dbusProxyObject;
@property (nonatomic, readonly) AJNProxyBusObject *allJoynProxyObject;
@property (nonatomic, readonly) AJNProxyBusObject *allJoynDebugProxyObject;

- (id)initWithApplicationName:(NSString*)applicationName allowingRemoteMessages:(BOOL)allowRemoteMessages;
- (void)destroy;

- (AJNInterfaceDescription*)createInterfaceWithName:(NSString*)interfaceName;
- (AJNInterfaceDescription*)interfaceWithName:(NSString*)interfaceName;
- (QStatus)deleteInterfaceWithName:(NSString*)interfaceName;
- (QStatus)deleteInterface:(AJNInterfaceDescription*)interfaceDescription;
- (QStatus)createInterfacesFromXml:(NSString*)xmlString;

- (void)registerBusListener:(id<AJNBusListener>)listener;
- (void)unregisterBusListener:(id<AJNBusListener>)listener;
- (void)destroyBusListener:(id<AJNBusListener>)listener;

- (void)registerSignalHandler:(id<AJNSignalHandler>)handler;
- (void)unregisterSignalHandler:(id<AJNSignalHandler>)handler;

- (QStatus)registerBusObject:(AJNBusObject*)busObject;
- (void)unregisterBusObject:(AJNBusObject*)busObject;

- (QStatus)start;
- (QStatus)stop;

- (QStatus)connectWithArguments:(NSString*)connectionArguments;
- (QStatus)disconnectWithArguments:(NSString*)connectionArguments;

- (QStatus)requestWellKnownName:(NSString*)name withFlags:(AJNBusNameFlag)flags;
- (QStatus)releaseWellKnownName:(NSString*)name;
- (BOOL)doesWellKnownNameHaveOwner:(NSString*)name;

- (QStatus)bindSessionOnPort:(AJNSessionPort)port withOptions:(AJNSessionOptions*)options withDelegate:(id<AJNSessionPortListener>)delegate;
- (QStatus)unbindSessionFromPort:(AJNSessionPort)port;
- (AJNSessionId)joinSessionWithName:(NSString*)sessionName onPort:(AJNSessionPort)sessionPort withDelegate:(id<AJNSessionListener>)delegate options:(AJNSessionOptions*)options;
- (QStatus)joinSessionAsyncWithName:(NSString*)sessionName onPort:(AJNSessionPort)sessionPort withDelegate:(id<AJNSessionListener>)delegate options:(AJNSessionOptions*)options joinCompletedDelegate:(id<AJNSessionDelegate>)completionDelegate context:(AJNHandle)context;
- (QStatus)joinSessionAsyncWithName:(NSString*)sessionName onPort:(AJNSessionPort)sessionPort withDelegate:(id<AJNSessionListener>)delegate options:(AJNSessionOptions*)options joinCompletedBlock:(AJNJoinSessionBlock)completionBlock context:(AJNHandle)context;
- (QStatus)bindSessionListener:(id<AJNSessionListener>)delegate toSession:(AJNSessionId)sessionId;
- (QStatus)leaveSession:(AJNSessionId)sessionId;
- (QStatus)setLinkTimeout:(uint32_t*)timeout forSession:(AJNSessionId)sessionId;
- (AJNHandle)socketFileDescriptorForSession:(AJNSessionId)sessionId;

- (QStatus)advertiseName:(NSString*)name withTransportMask:(AJNTransportMask)mask;
- (QStatus)cancelAdvertisedName:(NSString*)name withTransportMask:(AJNTransportMask)mask;
- (QStatus)findAdvertisedName:(NSString*)name;
- (QStatus)cancelFindAdvertisedName:(NSString*)name;

- (QStatus)addMatchRule:(NSString*)matchRule;
- (QStatus)removeMatchRule:(NSString*)matchRule;

- (QStatus)addLogonEntryToKeyStoreWithAuthenticationMechanism:(NSString*)authenticationMechanism userName:(NSString*)userName password:(NSString*)password;
- (QStatus)enablePeerSecurity:(NSString*)authenticationMechanisms authenticationListener:(id<AJNAuthenticationListener>)listener;
- (QStatus)enablePeerSecurity:(NSString*)authenticationMechanisms authenticationListener:(id<AJNAuthenticationListener>)listener keystoreFileName:(NSString*)fileName sharing:(BOOL)isShared;
- (QStatus)registerKeyStoreListener:(id<AJNKeyStoreListener>)listener;
- (QStatus)reloadKeyStore;
- (void)clearKeyStore;
- (QStatus)clearKeysForRemotePeerWithId:(NSString*)peerId;
- (QStatus)getKeyExpiration:(uint32_t*)timeout forRemotePeerId:(NSString*)peerId;
- (QStatus)setKeyExpiration:(uint32_t)timeout forRemotePeerId:(NSString*)peerId;

- (NSString*)guidForPeerNamed:(NSString*)peerName;

- (QStatus)setDaemonDebugLevel:(uint32_t)level forModule:(NSString*)module;

+ (uint32_t)currentTimeStamp;

@end
