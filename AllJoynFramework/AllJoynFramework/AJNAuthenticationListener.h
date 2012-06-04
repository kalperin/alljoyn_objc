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
#import <Status.h>
#import "AJNSecurityCredentials.h"
#import "AJNMessage.h"

@protocol AJNAuthenticationListener <NSObject>

@required

- (AJNSecurityCredentials*)requestSecurityCredentialsWithAuthenticationMechanism:(NSString*)authenticationMechanism peerName:(NSString*)peerName authenticationCount:(uint16_t)authenticationCount userName:(NSString*)userName credentialTypeMask:(AJNSecurityCredentialType)mask;

- (void)authenticationUsing:(NSString*)authenticationMechanism forRemotePeer:(NSString*)peer didCompleteWithStatus:(BOOL)success;

@optional

- (BOOL)verifySecurityCredentials:(AJNSecurityCredentials*)credentials usingAuthenticationMechanism:(NSString*)authenticationMechanism forRemotePeer:(NSString*)peerName;

- (void)securityViolationOccurredWithErrorCode:(QStatus)errorCode forMessage:(AJNMessage*)message;

@end
