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

/** @name Annotation flags */
// @{
typedef uint8_t AJNInterfaceAnnotationFlags;

static const AJNInterfaceAnnotationFlags kAJNInterfaceAnnotationNoReplyFlag     = 1; /**< No reply annotate flag */
static const AJNInterfaceAnnotationFlags kAJNInterfaceAnnotationDeprecatedFlag  = 2; /**< Deprecated annotate flag */
// @}

typedef enum {
    kAJNMessageTypeInvalid          = 0, ///< an invalid message type
    kAJNMessageTypeMethodCall       = 1, ///< a method call message type
    kAJNMessageTypeMethodReturn     = 2, ///< a method return message type
    kAJNMessageTypeError            = 3, ///< an error message type
    kAJNMessageTypeSignal           = 4  ///< a signal message type    
} AJNMessageType;

@interface AJNInterfaceMember : AJNObject

@property (nonatomic, readonly) AJNMessageType type;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *inputSignature;
@property (nonatomic, readonly) NSString *outputSignature;
@property (nonatomic, readonly) NSArray *argumentNames;
@property (nonatomic, readonly) AJNInterfaceAnnotationFlags annotation;
@property (nonatomic, readonly) NSString *accessPermissions;

@end
