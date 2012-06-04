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

/**
 * @name DBus RequestName input params
 * org.freedesktop.DBus.RequestName input params (see DBus spec)
 */
// @{
typedef NSInteger AJNBusNameFlag;

extern const AJNBusNameFlag kAJNBusNameFlagAllowReplacement;     /**< RequestName input flag: Allow others to take ownership of this name */
extern const AJNBusNameFlag kAJNBusNameFlagReplaceExisting;     /**< RequestName input flag: Attempt to take ownership of name if already taken */
extern const AJNBusNameFlag kAJNBusNameFlagDoNotQueue;     /**< RequestName input flag: Fail if name cannot be immediately obtained */

// @}
/**
 * @name DBus RequestName return values
 * org.freedesktop.DBUs.RequestName return values (see DBus spec)
 */
// @{
typedef enum {
    kAJNBusRequestNameReplyPrimaryOwner = 1,   /**< RequestName reply: Name was successfully obtained */
    kAJNBusRequestNameReplyInQueue      = 2,   /**< RequestName reply: Name is already owned, request for name has been queued */
    kAJNBusRequestNameReplyExists       = 3,   /**< RequestName reply: Name is already owned and DO_NOT_QUEUE was specified in request */
    kAJNBusRequestNameReplyAlreadyOwner = 4    /**< RequestName reply: Name is already owned by this endpoint */
} AJNBusRequestNameReply;
// @}

/**
 * @name DBus ReleaaseName return values
 * org.freedesktop.DBus.ReleaseName return values (see DBus spec)
 */
// @{
typedef enum {
    kAJNBusReleaseNameReplyReleased     = 1,     /**< ReleaseName reply: Name was released */
    kAJNBusReleaseNameReplyNonexistant  = 2,     /**< ReleaseName reply: Name does not exist */
    kAJNBusReleaseNameReplyNotOwner     = 3      /**< ReleaseName reply: Request to release name that is not owned by this endpoint */
} AJNBusReleaseNameReply;
// @}

/**
 * @name DBus StartServiceByName return values
 * org.freedesktop.DBus.StartService return values (see DBus spec)
 */
// @{
typedef enum {
    kAJNBusStartReplySuccess        = 1,         /**< StartServiceByName reply: Service is started */
    kAJNBusStartReplyAlreadyRunning = 2          /**< StartServiceByName reply: Service is already running */
} AJNBusStartReply;
// @}
