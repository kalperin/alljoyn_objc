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
#import "AJNStatus.h"
#import "AJNSessionOptions.h"

@class AJNBusAttachment;
@class AJNInterfaceDescription;
@class AJNMessageArgument;

/**
 * Message Bus Object base protocol. All application bus object protocols should inherit this.
 */
@protocol AJNBusObject<AJNHandle>

/**
 * Return the path for the object
 *
 * @return Object path
 */
@property (nonatomic, readonly) NSString *path;

/**
 * Get the name of this object.
 * The name is the last component of the path.
 *
 * @return Last component of object path.
 */
@property (nonatomic, readonly) NSString *name;

/**
 * AJNBusObject initialization.
 *
 * @param busAttachment  Bus that this object exists on.
 * @param path           Object path for object.
 */
- (id)initWithBusAttachment:(AJNBusAttachment *)busAttachment onPath:(NSString *)path;

/**
 * Called by the message bus when the object has been successfully registered. The object can
 * perform any initialization such as adding match rules at this time.
 */
- (void)objectWasRegistered;

/**
 * Emit PropertiesChanged to signal the bus that this property has been updated
 *
 *
 * @param propertyName  The name of the property being changed
 * @param interfaceName The name of the interface
 * @param value         The new value of the property
 * @param sessionId     ID of the session we broadcast the signal to (0 for all)
 */
- (void)emitPropertyWithName:(NSString *)propertyName onInterfaceWithName:(NSString *)interfaceName changedToValue:(AJNMessageArgument *)value inSession:(AJNSessionId)sessionId;


@end

////////////////////////////////////////////////////////////////////////////////

/**
 * Message Bus Object base class.
 */
@interface AJNBusObject : AJNObject<AJNBusObject>

@property (nonatomic, readonly) NSString *path;

@property (nonatomic, readonly) NSString *name;

- (id)initWithPath:(NSString *)path;

- (id)initWithBusAttachment:(AJNBusAttachment *)busAttachment onPath:(NSString *)path;

- (void)objectWasRegistered;

@end
