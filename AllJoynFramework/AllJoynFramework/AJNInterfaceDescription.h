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
#import "AJNInterfaceMember.h"
#import "AJNInterfaceProperty.h"
#import "AJNObject.h"

@interface AJNInterfaceDescription : AJNObject

@property (readonly, nonatomic) NSString *name;
@property (readonly, nonatomic) NSArray *members;
@property (readonly, nonatomic) NSArray *properties;
@property (readonly, nonatomic) NSString *xmlDescription;
@property (readonly, nonatomic) BOOL isSecure;
@property (readonly, nonatomic) BOOL hasProperties;

- (QStatus)addMethodWithName:(NSString*)methodName inputSignature:(NSString*)inputSignature outputSignature:(NSString*)outputSignature argumentNames:(NSArray*)arguments annotation:(AJNInterfaceAnnotationFlags)annotation accessPermissions:(NSString*)accessPermissions;
- (QStatus)addMethodWithName:(NSString*)methodName inputSignature:(NSString*)inputSignature outputSignature:(NSString*)outputSignature argumentNames:(NSArray*)arguments annotation:(AJNInterfaceAnnotationFlags)annotation;
- (QStatus)addMethodWithName:(NSString*)methodName inputSignature:(NSString*)inputSignature outputSignature:(NSString*)outputSignature argumentNames:(NSArray*)arguments;
- (AJNInterfaceMember*)methodWithName:(NSString*)methodName;

- (QStatus)addSignalWithName:(NSString*)name inputSignature:(NSString*)inputSignature argumentNames:(NSArray*)arguments;
- (QStatus)addSignalWithName:(NSString*)name inputSignature:(NSString*)inputSignature argumentNames:(NSArray*)arguments annotation:(AJNInterfaceAnnotationFlags)annotation;
- (QStatus)addSignalWithName:(NSString*)name inputSignature:(NSString*)inputSignature argumentNames:(NSArray*)arguments annotation:(uint8_t)annotation accessPermissions:(NSString*)permissions;
- (AJNInterfaceMember*)signalWithName:(NSString*)signalName;

- (QStatus)addPropertyWithName:(NSString*)name signature:(NSString*)signature;
- (QStatus)addPropertyWithName:(NSString*)name signature:(NSString*)signature accessPermissions:(AJNInterfacePropertyAccessPermissionsFlags)permissions;
- (AJNInterfaceProperty*)propertyWithName:(NSString*)propertyName;

- (AJNInterfaceMember*)memberWithName:(NSString*)name;
- (BOOL)hasMemberWithName:(NSString*)name inputSignature:(NSString*)inputs outputSignature:(NSString*)outputs;

- (void)activate;

@end
