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

////////////////////////////////////////////////////////////////////////////////

/** Invalid SessionPort value used to indicate that BindSessionPort should choose any available port */
extern const AJNSessionPort kAJNSessionPortAny;

////////////////////////////////////////////////////////////////////////////////

/** SessionId uniquely identifies an AllJoyn session instance */
typedef uint32_t AJNSessionId;

////////////////////////////////////////////////////////////////////////////////

/** Traffic type */
typedef enum {
    kAJNTrafficMessages      = 0x01,   /**< Session carries message traffic */
    kAJNTrafficRawUnreliable = 0x02,   /**< Session carries an unreliable (lossy) byte stream */
    kAJNTrafficRawReliable   = 0x04    /**< Session carries a reliable byte stream */
} AJNTrafficType;

////////////////////////////////////////////////////////////////////////////////

/** Proximity types */
typedef uint8_t AJNProximity;
extern const AJNProximity kAJNProximityAny;
extern const AJNProximity kAJNProximityPhysical;
extern const AJNProximity kAJNProximityNetwork;

////////////////////////////////////////////////////////////////////////////////

/**
 * A class that contains a set of parameters defining a Session's characteristics.
 */
@interface AJNSessionOptions : AJNObject

/**
 * Traffic type
 */
@property (nonatomic) AJNTrafficType trafficType;

/**
 * Multi-point session capable.
 * A session is multi-point if it can be joined multiple times to form a single
 * session with multi (greater than 2) endpoints. When false, each join attempt
 * creates a new point-to-point session.
 */
@property (nonatomic) BOOL isMultipoint;

/**
 * Proximity
 */
@property (nonatomic) AJNProximity proximity;

/**
 * Allowed transports
 */
@property (nonatomic) AJNTransportMask transports;


/**
 * Initialize a Session Options object with specific parameters.
 *
 * @param traffic       Type of traffic.
 * @param isMultipoint  true iff session supports multipoint (greater than two endpoints).
 * @param proximity     Proximity constraint bitmask.
 * @param transports    Allowed transport types bitmask.
 *
 */
- (id)initWithTrafficType:(AJNTrafficType)traffic supportsMultipoint:(BOOL)isMultipoint proximity:(AJNProximity)proximity transportMask:(AJNTransportMask)transports;

/*
 * Default initializer
 */
- (id)init;

/**
 * Determine whether this SessionOpts is compatible with the SessionOpts offered by other
 *
 * @param sessionOptions Options to be compared against this one.
 * @return true iff this SessionOpts can use the option set offered by other.
 */
- (BOOL)isCompatibleWithSessionOptions:(AJNSessionOptions *)sessionOptions;

/**
 * Compare SessionOpts
 *
 * @param object other the SessionOpts being compared against
 * @return true if all of the SessionOpts parameters are the same
 *
 */
- (BOOL)isEqual:(id)object;

/**
 * Rather arbitrary less-than operator to allow containers holding SessionOpts
 * to be sorted.
 * Traffic takes precedence when sorting SessionOpts.
 *
 * TRAFFIC_MESSAGES \< TRAFFIC_RAW_UNRELIABLE \< TRAFFIC_RAW_RELIABLE
 *
 * If traffic is equal then Proximity takes next level of precedence.
 *
 * PROXIMITY_PHYSICAL \< PROXIMITY_NETWORK \< PROXIMITY_ANY
 *
 * last transports.
 *
 * TRANSPORT_LOCAL \< TRANSPORT_BLUETOOTH \< TRANSPORT_WLAN \< TRANSPORT_WWAN \< TRANSPORT_ANY
 *
 *
 * @param sessionOptions the SessionOpts being compared against
 * @return true if this SessionOpts is designated as less than the SessionOpts
 *         being compared against.
 */
- (BOOL)isLessThanSessionOptions:(AJNSessionOptions *)sessionOptions;

@end
