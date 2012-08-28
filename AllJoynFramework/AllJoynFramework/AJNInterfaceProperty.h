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

/** Property access permissions flag type */
typedef uint8_t AJNInterfacePropertyAccessPermissionsFlags;

/** Read-only property access permissions flag */
static const AJNInterfacePropertyAccessPermissionsFlags kAJNInterfacePropertyAccessReadFlag      = 1;
/** Write-only property access permissions flag */
static const AJNInterfacePropertyAccessPermissionsFlags kAJNInterfacePropertyAccessWriteFlag     = 2;
/** Read-Write property access permissions flag */
static const AJNInterfacePropertyAccessPermissionsFlags kAJNInterfacePropertyAccessReadWriteFlag = 3;

////////////////////////////////////////////////////////////////////////////////

/**
 * A class that contains the metadata for a property of an interface 
 */
@interface AJNInterfaceProperty : AJNObject

/** Name of the property */
@property (nonatomic, readonly) NSString *name;

/** Signature of the property */
@property (nonatomic, readonly) NSString *signature;

/** Access permissions flags for the property */
@property (nonatomic, readonly) AJNInterfacePropertyAccessPermissionsFlags accessPermissions;

/**
 * Get an annotation value for the property
 *
 * @param annotationName    Name of annotation 
 *
 * @return  - string value of annotation if found
 *          - nil if not found
 */
- (NSString *)annotationWithName:(NSString *)annotationName;

@end
