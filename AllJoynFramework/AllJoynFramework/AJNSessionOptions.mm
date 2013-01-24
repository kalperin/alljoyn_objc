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

#import <alljoyn/Session.h>
#import "AJNSessionOptions.h"

/** Invalid SessionPort value used to indicate that BindSessionPort should choose any available port */
const AJNSessionPort kAJNSessionPortAny = 0;

/** Proximity types */
const AJNProximity kAJNProximityAny      = 0xFF;
const AJNProximity kAJNProximityPhysical = 0x01;
const AJNProximity kAJNProximityNetwork  = 0x02;

@interface AJNObject(Private)

/**
 * Flag indicating whether or not the object pointed to by handle should be deleted when an instance of this class is deallocated.
 */
@property (nonatomic) BOOL shouldDeleteHandleOnDealloc;

@end


@implementation AJNSessionOptions

/**
 * Helper to return the C++ API object that is encapsulated by this objective-c class
 */
- (ajn::SessionOpts*)sessionOpts
{
    return (ajn::SessionOpts*)self.handle;
}

- (AJNTrafficType)trafficType
{
    return (AJNTrafficType)self.sessionOpts->traffic;
}

- (void)setTrafficType:(AJNTrafficType)trafficType
{
    self.sessionOpts->traffic = (ajn::SessionOpts::TrafficType)trafficType;
}

- (BOOL)isMultipoint
{
    return self.sessionOpts->isMultipoint;
}

- (void)setIsMultipoint:(BOOL)isMultipoint
{
    self.sessionOpts->isMultipoint = isMultipoint;
}

- (AJNProximity)proximity
{
    return self.sessionOpts->proximity;
}

- (void)setProximity:(AJNProximity)proximity
{
    self.sessionOpts->proximity = proximity;
}

- (AJNTransportMask)transports
{
    return self.sessionOpts->transports;
}

- (void)setTransports:(AJNTransportMask)transports
{
    self.sessionOpts->transports = transports;
}

- (id)initWithTrafficType:(AJNTrafficType)traffic supportsMultipoint:(BOOL)isMultipoint proximity:(AJNProximity)proximity transportMask:(AJNTransportMask)transports
{
    self = [super init];
    if (self) {
        ajn::SessionOpts *options = new ajn::SessionOpts((ajn::SessionOpts::TrafficType)traffic, isMultipoint == YES, proximity, transports);
        self.handle = options;
        self.shouldDeleteHandleOnDealloc = YES;
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        ajn::SessionOpts *options = new ajn::SessionOpts();
        self.handle = options;
        self.shouldDeleteHandleOnDealloc = YES;
    }
    return self;
}

- (void)dealloc
{
    if (self.shouldDeleteHandleOnDealloc) {
        delete self.sessionOpts;
        self.handle = nil;
    }
}

- (BOOL)isCompatibleWithSessionOptions:(AJNSessionOptions*)sessionOptions
{
    return self.sessionOpts->IsCompatible(*sessionOptions.sessionOpts);
}

- (BOOL)isEqual:(id)object
{
    BOOL result = NO;
    if ([object isKindOfClass:[AJNSessionOptions class]]) {
        result = *self.sessionOpts == *[object sessionOpts];
    }
    return result;
}

- (BOOL)isLessThanSessionOptions:(AJNSessionOptions*)sessionOptions
{
    return *self.sessionOpts < *[sessionOptions sessionOpts];
}

@end
