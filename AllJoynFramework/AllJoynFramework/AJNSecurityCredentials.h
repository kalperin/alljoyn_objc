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

/**
 * @name Credential indication Bitmasks
 *  Bitmasks used to indicated what type of credentials are being used.
 */
// @{
typedef uint16_t AJNSecurityCredentialType;

/**< Bit 0 indicates credentials include a password, pincode, or passphrase */
extern const AJNSecurityCredentialType kAJNSecurityCredentialTypePassword; 

/**< Bit 1 indicates credentials include a user name */
extern const AJNSecurityCredentialType kAJNSecurityCredentialTypeUserName; 

/**< Bit 2 indicates credentials include a chain of PEM-encoded X509 certificates */
extern const AJNSecurityCredentialType kAJNSecurityCredentialTypeCertificateChain; 

/**< Bit 3 indicates credentials include a PEM-encoded private key */
extern const AJNSecurityCredentialType kAJNSecurityCredentialTypePrivateKey; 

/**< Bit 4 indicates credentials include a logon entry that can be used to logon a remote user */
extern const AJNSecurityCredentialType kAJNSecurityCredentialTypeLogonEntry; 

/**< Bit 5 indicates credentials include an expiration time */
extern const AJNSecurityCredentialType kAJNSecurityCredentialTypeExpirationTime; 
// @}

/**
 * @name Credential request values
 * These values are only used in a credential request
 */
// @{

typedef uint16_t AJNSecurityCredentialRequest;

/**< Indicates the credential request is for a newly created password */
extern const uint16_t AJNSecurityCredentialRequestNewPassword; 

/**< Indicates the credential request is for a one time use password */
extern const uint16_t AJNSecurityCredentialRequestOneTimePassword; 
// @}

@interface AJNSecurityCredentials : AJNObject

@property (nonatomic) NSString *password;
@property (nonatomic) NSString *userName;
@property (nonatomic) NSString *certificateChain;
@property (nonatomic) NSString *privateKey;
@property (nonatomic) NSString *logonEntry;
@property (nonatomic) NSInteger expirationTime;

- (BOOL)isCredentialTypeSet:(AJNSecurityCredentialType)type;
- (void)clear;

@end
