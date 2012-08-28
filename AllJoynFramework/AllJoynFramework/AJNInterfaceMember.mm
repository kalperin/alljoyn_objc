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

#import <alljoyn/InterfaceDescription.h>
#import "AJNHandle.h"
#import "AJNInterfaceMember.h"

@interface AJNInterfaceMember()

/**
 * Helper to return the C++ API object that is encapsulated by this objective-c class
 */
@property (nonatomic, readonly) ajn::InterfaceDescription::Member *member;

@end

@implementation AJNInterfaceMember

- (AJNMessageType)type
{
    return (AJNMessageType)self.member->memberType;
}

- (NSString *)name
{
    return [NSString stringWithCString:self.member->name.c_str() encoding:NSUTF8StringEncoding];
}

- (NSString *)inputSignature
{
    return [NSString stringWithCString:self.member->signature.c_str() encoding:NSUTF8StringEncoding];
}

- (NSString *)outputSignature
{
    return [NSString stringWithCString:self.member->returnSignature.c_str() encoding:NSUTF8StringEncoding];
}

- (NSArray *)argumentNames
{
    return [[NSString stringWithCString:self.member->argNames.c_str() encoding:NSUTF8StringEncoding] componentsSeparatedByString:@","];
}

- (NSString *)accessPermissions
{
    return [NSString stringWithCString:self.member->accessPerms.c_str() encoding:NSUTF8StringEncoding];
}

/**
 * Helper to return the C++ API object that is encapsulated by this objective-c class
 */
- (ajn::InterfaceDescription::Member*)member
{
    return static_cast<ajn::InterfaceDescription::Member*>(self.handle);
}

- (id)initWithHandle:(AJNHandle)handle
{
    self = [super initWithHandle:handle];
    if (self) {
    }
    return self;
}

- (NSString *)annotationWithName:(NSString *)annotationName
{
    qcc::String value;
    bool wasMemberFound = self.member->GetAnnotation([annotationName UTF8String], value);
    NSString *annotationValue;
    if (wasMemberFound) {
        annotationValue = [NSString stringWithCString:value.c_str() encoding:NSUTF8StringEncoding];
    }
    return annotationValue;
}

@end
