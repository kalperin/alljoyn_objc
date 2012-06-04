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

#import "AJNObject.h"
#import "AJNInterfaceMember.h"

@interface AJNMessage : AJNObject

@property (nonatomic, readonly) BOOL isBroadcastSignal;
@property (nonatomic, readonly) BOOL isGlobalBroadcast;
@property (nonatomic, readonly) uint8_t flags;
@property (nonatomic, readonly) BOOL isExpired;
@property (nonatomic, readonly) uint32_t timeUntilExpiration;
@property (nonatomic, readonly) BOOL isEncrypted;
@property (nonatomic, readonly) NSString *authenticationMechanism;
@property (nonatomic, readonly) AJNMessageType type;
@property (nonatomic, readonly) NSArray *arguments;
@property (nonatomic, readonly) uint32_t callSerialNumber;
@property (nonatomic, readonly) uint32_t replySerialNumber;
@property (nonatomic, readonly) NSString *signature;
@property (nonatomic, readonly) NSString *objectPath;
@property (nonatomic, readonly) NSString *interfaceName;
@property (nonatomic, readonly) NSString *memberName;
@property (nonatomic, readonly) NSString *senderName;
@property (nonatomic, readonly) NSString *receiverEndpointName;
@property (nonatomic, readonly) NSString *destination;
@property (nonatomic, readonly) uint32_t compressionToken;
@property (nonatomic, readonly) uint32_t sessionId;
@property (nonatomic, readonly) NSString *errorName;
@property (nonatomic, readonly) NSString *errorDescription;
@property (nonatomic, readonly) NSString *description;
@property (nonatomic, readonly) NSString *xmlDescription;
@property (nonatomic, readonly) uint32_t timeStamp;

@end
