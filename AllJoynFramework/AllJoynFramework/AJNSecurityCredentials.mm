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

#import "AJNSecurityCredentials.h"
#import <alljoyn/AuthListener.h>

const AJNSecurityCredentialType kAJNSecurityCredentialTypePassword     = 0x0001; /**< Bit 0 indicates credentials include a password, pincode, or passphrase */
const AJNSecurityCredentialType kAJNSecurityCredentialTypeUserName    = 0x0002; /**< Bit 1 indicates credentials include a user name */
const AJNSecurityCredentialType kAJNSecurityCredentialTypeCertificateChain   = 0x0004; /**< Bit 2 indicates credentials include a chain of PEM-encoded X509 certificates */
const AJNSecurityCredentialType kAJNSecurityCredentialTypePrivateKey  = 0x0008; /**< Bit 3 indicates credentials include a PEM-encoded private key */
const AJNSecurityCredentialType kAJNSecurityCredentialTypeLogonEntry  = 0x0010; /**< Bit 4 indicates credentials include a logon entry that can be used to logon a remote user */
const AJNSecurityCredentialType kAJNSecurityCredentialTypeExpirationTime   = 0x0020; /**< Bit 5 indicates credentials include an  expiration time */

const uint16_t AJNSecurityCredentialRequestNewPassword = 0x1001; /**< Indicates the credential request is for a newly created password */
const uint16_t AJNSecurityCredentialRequestOneTimePassword = 0x2001; /**< Indicates the credential request is for a one time use password */

@implementation AJNSecurityCredentials

- (ajn::AuthListener::Credentials*)credentials
{
    return static_cast<ajn::AuthListener::Credentials*>(self.handle);
}

- (NSString*)password
{
    return [NSString stringWithCString:self.credentials->GetPassword().c_str() encoding:NSUTF8StringEncoding];
}

- (void)setPassword:(NSString *)password
{
    self.credentials->SetPassword([password UTF8String]);
}

- (NSString*)userName
{
    return [NSString stringWithCString:self.credentials->GetUserName().c_str() encoding:NSUTF8StringEncoding];
}

- (void)setUserName:(NSString *)userName
{
    self.credentials->SetUserName([userName UTF8String]);
}

- (NSString*)logonEntry
{
    return [NSString stringWithCString:self.credentials->GetLogonEntry().c_str() encoding:NSUTF8StringEncoding];
}

- (void)setLogonEntry:(NSString *)logonEntry
{
    self.credentials->SetLogonEntry([logonEntry UTF8String]);
}

- (NSString*)privateKey
{
    return [NSString stringWithCString:self.credentials->GetPrivateKey().c_str() encoding:NSUTF8StringEncoding];
}

- (void)setPrivateKey:(NSString *)privateKey
{
    self.credentials->SetPrivateKey([privateKey UTF8String]);
}

- (NSString*)certificateChain
{
    return [NSString stringWithCString:self.credentials->GetCertChain().c_str() encoding:NSUTF8StringEncoding];
}

- (void)setCertificateChain:(NSString *)certificateChain
{
    self.credentials->SetCertChain([certificateChain UTF8String]);
}

- (NSInteger)expirationTime
{
    return self.credentials->GetExpiration();
}

- (void)setExpirationTime:(NSInteger)expirationTime
{
    self.credentials->SetExpiration(expirationTime);
}

- (BOOL)isCredentialTypeSet:(AJNSecurityCredentialType)type
{
    return self.credentials->IsSet(type) == true;
}

- (void)clear
{
    self.credentials->Clear();
}

@end
