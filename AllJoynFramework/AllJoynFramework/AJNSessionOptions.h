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
#import "AJNTransportMask.h"
#import "AJNObject.h"

/**
 * SessionPort identifies a per-BusAttachment receiver for incoming JoinSession requests.
 * SessionPort values are bound to a BusAttachment when the attachment calls
 * BindSessionPort.
 *
 * NOTE: Valid SessionPort values range from 1 to 0xFFFF.
 */
typedef uint16_t AJNSessionPort;

/** Invalid SessionPort value used to indicate that BindSessionPort should choose any available port */
extern const AJNSessionPort kAJNSessionPortAny;

/** SessionId uniquely identifies an AllJoyn session instance */
typedef uint32_t AJNSessionId;

/** Traffic type */
typedef enum {
    kAJNTrafficMessages      = 0x01,   /**< Session carries message traffic */
    kAJNTrafficRawUnreliable = 0x02,   /**< Session carries an unreliable (lossy) byte stream */
    kAJNTrafficRawReliable   = 0x04    /**< Session carries a reliable byte stream */
} AJNTrafficType;

/** Proximity types */
typedef uint8_t AJNProximity;
extern const AJNProximity kAJNProximityAny;
extern const AJNProximity kAJNProximityPhysical;
extern const AJNProximity kAJNProximityNetwork;

@interface AJNSessionOptions : AJNObject

@property (nonatomic) AJNTrafficType trafficType;
@property (nonatomic) BOOL isMultipoint;
@property (nonatomic) AJNProximity proximity;
@property (nonatomic) AJNTransportMask transports;

- (id)initWithTrafficType:(AJNTrafficType)traffic supportsMultipoint:(BOOL)isMultipoint proximity:(AJNProximity)proximity transportMask:(AJNTransportMask)transports;

- (id)init;

- (BOOL)isCompatibleWithSessionOptions:(AJNSessionOptions*)sessionOptions;

- (BOOL)isEqual:(id)object;

- (BOOL)isLessThanSessionOptions:(AJNSessionOptions*)sessionOptions;

@end
