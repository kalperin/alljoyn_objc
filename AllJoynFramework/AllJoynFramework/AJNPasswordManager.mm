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

#import <objc/runtime.h>
#import <qcc/String.h>
#import <alljoyn/PasswordManager.h>
#import "AJNPasswordManager.h"

using namespace ajn;

@implementation AJNPasswordManager

+(QStatus)setCredentialsForAuthMechanism:(NSString *)authMechanism usingPassword:(NSString *)password
{
    QStatus status = PasswordManager::SetCredentials([authMechanism UTF8String], [password UTF8String]);
    if (status != ER_OK) {
        NSLog(@"ERROR: AJNPasswordManager::setCredentialsForAuthMechanism:%@ usingPassword:%@ failed. %@",authMechanism, password, [AJNStatus descriptionForStatusCode:status]);
    }
    return status;
}

@end