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
#import "AJNInterfaceDescription.h"

@interface AJNInterfaceDescription()

@property (nonatomic, readonly) ajn::InterfaceDescription* interfaceDescription;

@end

@implementation AJNInterfaceDescription

- (ajn::InterfaceDescription*)interfaceDescription
{
    return static_cast<ajn::InterfaceDescription*>(self.handle);
}

- (NSString*)name
{
    return [NSString stringWithCString:self.interfaceDescription->GetName() encoding:NSUTF8StringEncoding];
}

- (NSArray*)members
{
    size_t memberCount = self.interfaceDescription->GetMembers();
    NSMutableArray *members = [[NSMutableArray alloc] initWithCapacity:memberCount];
    const ajn::InterfaceDescription::Member** pInterfaceMembers = new const ajn::InterfaceDescription::Member *[memberCount];
    self.interfaceDescription->GetMembers(pInterfaceMembers, memberCount);
    for (int i = 0; i < memberCount; i++) {
        const ajn::InterfaceDescription::Member *member = pInterfaceMembers[i];
        [members addObject:[[AJNInterfaceMember alloc] initWithHandle:(AJNHandle)member]];
    }
    delete [] pInterfaceMembers;
    return members;
}

- (NSArray*)properties
{
    size_t propertyCount = self.interfaceDescription->GetProperties();
    NSMutableArray *properties = [[NSMutableArray alloc] initWithCapacity:propertyCount];
    const ajn::InterfaceDescription::Property** pInterfaceProperties = new const ajn::InterfaceDescription::Property *[propertyCount];
    self.interfaceDescription->GetProperties(pInterfaceProperties, propertyCount);
    for (int i = 0; i < propertyCount; i++) {
        const ajn::InterfaceDescription::Property *property = pInterfaceProperties[i];
        [properties addObject:[[AJNInterfaceProperty alloc] initWithHandle:(AJNHandle)property]];
    }
    delete [] pInterfaceProperties;
    return properties;
}

- (NSString*)xmlDescription
{
    return [NSString stringWithCString:self.interfaceDescription->Introspect(2).c_str() encoding:NSUTF8StringEncoding];
}

- (BOOL)isSecure
{
    return self.interfaceDescription->IsSecure();
}

- (BOOL)hasProperties
{
    return self.interfaceDescription->HasProperties() ? YES : NO;
}

- (QStatus)addMethodWithName:(NSString*)methodName inputSignature:(NSString*)inputSignature outputSignature:(NSString*)outputSignature argumentNames:(NSArray*)arguments annotation:(AJNInterfaceAnnotationFlags)annotation accessPermissions:(NSString*)accessPermissions
{
    QStatus result = ER_OK;
    if (self.interfaceDescription) {
        result = self.interfaceDescription->AddMethod([methodName UTF8String], [inputSignature UTF8String], [outputSignature UTF8String], [[arguments componentsJoinedByString:@","] UTF8String], annotation, [accessPermissions UTF8String]);
        if (result != ER_OK && result != ER_BUS_MEMBER_ALREADY_EXISTS) {
            NSLog(@"ERROR: Failed to create method named %@. %s", methodName, QCC_StatusText(result) );
        }
    }
    return result;
}

- (QStatus)addMethodWithName:(NSString*)methodName inputSignature:(NSString*)inputSignature outputSignature:(NSString*)outputSignature argumentNames:(NSArray*)arguments annotation:(AJNInterfaceAnnotationFlags)annotation
{
    return [self addMethodWithName:methodName inputSignature:inputSignature outputSignature:outputSignature argumentNames:arguments annotation:annotation accessPermissions:nil];
}

- (QStatus)addMethodWithName:(NSString*)methodName inputSignature:(NSString*)inputSignature outputSignature:(NSString*)outputSignature argumentNames:(NSArray*)arguments
{
    return [self addMethodWithName:methodName inputSignature:inputSignature outputSignature:outputSignature argumentNames:arguments annotation:0 accessPermissions:nil];
}

- (AJNInterfaceMember*)methodWithName:(NSString *)methodName
{
    return [[AJNInterfaceMember alloc] initWithHandle:(AJNHandle)self.interfaceDescription->GetMethod([methodName UTF8String])];
}

- (QStatus) addSignalWithName:(NSString *)name inputSignature:(NSString *)inputSignature argumentNames:(NSArray *)arguments
{
    return [self addSignalWithName:name inputSignature:inputSignature argumentNames:arguments annotation:0 accessPermissions:nil];
}

- (QStatus)addSignalWithName:(NSString *)name inputSignature:(NSString *)inputSignature argumentNames:(NSArray *)arguments annotation:(AJNInterfaceAnnotationFlags)annotation
{
    return [self addSignalWithName:name inputSignature:inputSignature argumentNames:arguments annotation:annotation accessPermissions:nil];
}

- (QStatus)addSignalWithName:(NSString *)name inputSignature:(NSString *)inputSignature argumentNames:(NSArray *)arguments annotation:(AJNInterfaceAnnotationFlags)annotation accessPermissions:(NSString *)permissions
{
    QStatus result = ER_OK;
    if (self.interfaceDescription) {
        result = self.interfaceDescription->AddSignal([name UTF8String], [inputSignature UTF8String], [[arguments componentsJoinedByString:@","] UTF8String], annotation, [permissions UTF8String]);
        if (result != ER_OK && result != ER_BUS_MEMBER_ALREADY_EXISTS) {
            NSLog(@"ERROR: Failed to create signal named %@. %s", name, QCC_StatusText(result) );
        }
    }
    return result;    
}

- (AJNInterfaceMember*)signalWithName:(NSString *)signalName
{
    return [[AJNInterfaceMember alloc] initWithHandle:(AJNHandle)self.interfaceDescription->GetSignal([signalName UTF8String])];    
}

- (QStatus)addPropertyWithName:(NSString*)name signature:(NSString*)signature
{
    return [self addPropertyWithName:name signature:signature accessPermissions:kAJNInterfacePropertyAccessReadWriteFlag];
}

- (QStatus)addPropertyWithName:(NSString*)name signature:(NSString*)signature accessPermissions:(AJNInterfacePropertyAccessPermissionsFlags)permissions
{
    QStatus result = ER_OK;
    if (self.interfaceDescription) {
        result = self.interfaceDescription->AddProperty([name UTF8String], [signature UTF8String], permissions);
        if (result != ER_OK && result != ER_BUS_MEMBER_ALREADY_EXISTS) {
            NSLog(@"ERROR: Failed to create signal named %@. %s", name, QCC_StatusText(result) );
        }
    }
    return result;
}

- (AJNInterfaceProperty*)propertyWithName:(NSString *)propertyName
{
    return [[AJNInterfaceProperty alloc] initWithHandle:(AJNHandle)self.interfaceDescription->GetProperty([propertyName UTF8String])];        
}

- (AJNInterfaceMember*)memberWithName:(NSString*)name
{
    const ajn::InterfaceDescription::Member *member = self.interfaceDescription->GetMember([name UTF8String]);
    AJNInterfaceMember *interfaceMember;
    if (member) {
        interfaceMember = [[AJNInterfaceMember alloc] initWithHandle:(AJNHandle)member];
    }
    return interfaceMember;
}

- (BOOL)hasMemberWithName:(NSString *)name inputSignature:(NSString *)inputs outputSignature:(NSString *)outputs
{
    return self.interfaceDescription->HasMember([name UTF8String], [inputs UTF8String], [outputs UTF8String]) ? YES : NO;
}

- (void)activate
{
    if (self.interfaceDescription) {
        self.interfaceDescription->Activate();
    }
}

@end
