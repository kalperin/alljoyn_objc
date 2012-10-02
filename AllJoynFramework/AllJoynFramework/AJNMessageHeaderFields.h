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

/**
 * AllJoyn Header field types
 */
typedef enum {

    /* Wire-protocol defined header field types */
    kAJNMessageHeaderFieldTypeInvalid = 0,              ///< an invalid header field type
    kAJNMessageHeaderFieldTypePath,                     ///< an object path header field type
    kAJNMessageHeaderFieldTypeInterface,                ///< a message interface header field type
    kAJNMessageHeaderFieldTypeMember,                   ///< a member (message/signal) name header field type
    kAJNMessageHeaderFieldTypeErrorName,               ///< an error name header field type
    kAJNMessageHeaderFieldTypeReplySerial,             ///< a reply serial number header field type
    kAJNMessageHeaderFieldTypeDestination,              ///< message destination header field type
    kAJNMessageHeaderFieldTypeSender,                   ///< senders well-known name header field type
    kAJNMessageHeaderFieldTypeSignature,                ///< message signature header field type
    kAJNMessageHeaderFieldTypeHandles,                  ///< number of file/socket handles that accompany the message
    /* AllJoyn defined header field types */
    kAJNMessageHeaderFieldTypeTimestamp,                ///< time stamp header field type
    kAJNMessageHeaderFieldTypeTimeToLive,             ///< messages time-to-live header field type
    kAJNMessageHeaderFieldTypeCompressionToken,        ///< message compression token header field type
    kAJNMessageHeaderFieldTypeSessionId,               ///< Session id field type
    kAJNMessageHeaderFieldTypeFieldUnknown                   ///< unknown header field type also used as maximum number of header field types.
} AJNMessageHeaderFieldType;

////////////////////////////////////////////////////////////////////////////////

/**
 * AllJoyn header fields
 */
@interface AJNMessageHeaderFields : AJNObject

/**
 * The values of each header field. Each element in the values array is an AJNMessageArgument.
 */
@property (nonatomic, readonly) NSArray*values;

/**
 * The string representation of the header fields.
 */
- (NSString*)stringValue;

@end
