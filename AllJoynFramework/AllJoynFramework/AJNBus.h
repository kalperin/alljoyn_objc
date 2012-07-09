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

/**< RequestName input flag: Allow others to take ownership of this name */
extern const AJNBusNameFlag kAJNBusNameFlagAllowReplacement;    
/**< RequestName input flag: Attempt to take ownership of name if already taken */
extern const AJNBusNameFlag kAJNBusNameFlagReplaceExisting;
/**< RequestName input flag: Fail if name cannot be immediately obtained */
extern const AJNBusNameFlag kAJNBusNameFlagDoNotQueue;     

// @}

////////////////////////////////////////////////////////////////////////////////

/**
 * @name DBus RequestName return values
 * org.freedesktop.DBUs.RequestName return values (see DBus spec)
 */
// @{
typedef enum {
    /**< RequestName reply: Name was successfully obtained */    
    kAJNBusRequestNameReplyPrimaryOwner = 1,   
    /**< RequestName reply: Name is already owned, request for name has been queued */    
    kAJNBusRequestNameReplyInQueue      = 2,   
    /**< RequestName reply: Name is already owned and DO_NOT_QUEUE was specified in request */    
    kAJNBusRequestNameReplyExists       = 3,   
    /**< RequestName reply: Name is already owned by this endpoint */
    kAJNBusRequestNameReplyAlreadyOwner = 4
} AJNBusRequestNameReply;
// @}

////////////////////////////////////////////////////////////////////////////////

/**
 * @name DBus ReleaaseName return values
 * org.freedesktop.DBus.ReleaseName return values (see DBus spec)
 */
// @{
typedef enum {
    /**< ReleaseName reply: Name was released */    
    kAJNBusReleaseNameReplyReleased     = 1,     
    /**< ReleaseName reply: Name does not exist */
    kAJNBusReleaseNameReplyNonexistant  = 2,     
    /**< ReleaseName reply: Request to release name that is not owned by this endpoint */
    kAJNBusReleaseNameReplyNotOwner     = 3      
} AJNBusReleaseNameReply;
// @}

////////////////////////////////////////////////////////////////////////////////

/**
 * @name DBus StartServiceByName return values
 * org.freedesktop.DBus.StartService return values (see DBus spec)
 */
// @{
typedef enum {
    /**< StartServiceByName reply: Service is started */    
    kAJNBusStartReplySuccess        = 1,         
    /**< StartServiceByName reply: Service is already running */
    kAJNBusStartReplyAlreadyRunning = 2          
} AJNBusStartReply;
// @}
