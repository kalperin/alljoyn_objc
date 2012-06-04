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

@class AJNBusAttachment;
@class AJNInterfaceDescription;

@protocol AJNBusObject<AJNHandle>

@property (nonatomic, readonly) NSString *path;

@property (nonatomic, readonly) NSString *name;

- (id)initWithBusAttachment:(AJNBusAttachment*)busAttachment onPath:(NSString*)path;

- (void)objectWasRegistered;

@end

@interface AJNBusObject : AJNObject<AJNBusObject>

@property (nonatomic, readonly) NSString *path;

@property (nonatomic, readonly) NSString *name;

- (id)initWithBusAttachment:(AJNBusAttachment*)busAttachment onPath:(NSString*)path;

- (void)objectWasRegistered;

@end
