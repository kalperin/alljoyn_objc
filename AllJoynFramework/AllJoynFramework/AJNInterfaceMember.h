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

/**< No reply annotate flag */
static const AJNInterfaceAnnotationFlags kAJNInterfaceAnnotationNoReplyFlag     = 1;
/**< Deprecated annotate flag */
static const AJNInterfaceAnnotationFlags kAJNInterfaceAnnotationDeprecatedFlag  = 2;
// @}

////////////////////////////////////////////////////////////////////////////////

/**
 *  Message type enumeration
 */
typedef enum {

    ///< an invalid message type
    kAJNMessageTypeInvalid          = 0,

    ///< a method call message type
    kAJNMessageTypeMethodCall       = 1,

    ///< a method return message type
    kAJNMessageTypeMethodReturn     = 2,

    ///< an error message type
    kAJNMessageTypeError            = 3,

    ///< a signal message type
    kAJNMessageTypeSignal           = 4

} AJNMessageType;

////////////////////////////////////////////////////////////////////////////////

/**
 * Class representing a member of an interface.
 */
@interface AJNInterfaceMember : AJNObject

/**
 * Type of the member.
 */
@property (nonatomic, readonly) AJNMessageType type;

/**
 * Name of the member.
 */
@property (nonatomic, readonly) NSString *name;

/**
 * Input type signature of the member. This is nil for a signal member.
 */
@property (nonatomic, readonly) NSString *inputSignature;

/**
 * Output type signature of the member.
 */
@property (nonatomic, readonly) NSString *outputSignature;

/**
 * Comma separated list of names of all arguments. This can be nil.
 */
@property (nonatomic, readonly) NSArray *argumentNames;

/**
 * Required permissions to invoke this call.
 */
@property (nonatomic, readonly) NSString *accessPermissions;

/**
 * Get the annotation value for the member
 *
 * @param annotationName    Name of annotation
 *
 * @return  - string value of annotation if found
 *          - nil if not found
 */
- (NSString *)annotationWithName:(NSString *)annotationName;

@end
