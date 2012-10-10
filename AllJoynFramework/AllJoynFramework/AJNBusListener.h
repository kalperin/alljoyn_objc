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
#import "AJNTransportMask.h"

@class AJNBusAttachment;


/**
 * Protocol implemented by AllJoyn apps and called by AllJoyn to inform
 * apps of bus related events.
 */
@protocol AJNBusListener <NSObject>

@optional

/**
 * Called by the bus when the listener is registered. This gives the listener implementation the
 * opportunity to save a reference to the bus.
 *
 * @param busAttachment  The bus the listener is registered with.
 */
- (void)listenerDidRegisterWithBus:(AJNBusAttachment *)busAttachment;

/**
 * Called by the bus when the listener is unregistered.
 * @param busAttachment  The bus the listener is unregistering with.
 */
- (void)listenerDidUnregisterWithBus:(AJNBusAttachment *)busAttachment;

/**
 * Called by the bus when an external bus is discovered that is advertising a well-known name
 * that this attachment has registered interest in via a DBus call to org.alljoyn.Bus.FindAdvertisedName
 *
 * @param name         A well known name that the remote bus is advertising.
 * @param transport    Transport that received the advertisement.
 * @param namePrefix   The well-known name prefix used in call to FindAdvertisedName that triggered this callback.
 */
- (void)didFindAdvertisedName:(NSString *)name withTransportMask:(AJNTransportMask) transport namePrefix:(NSString *)namePrefix;

/**
 * Called by the bus when an advertisement previously reported through FoundName has become unavailable.
 *
 * @param name         A well known name that the remote bus is advertising that is of interest to this attachment.
 * @param transport    Transport that stopped receiving the given advertised name.
 * @param namePrefix   The well-known name prefix that was used in a call to FindAdvertisedName that triggered this callback.
 */
- (void)didLoseAdvertisedName:(NSString *)name withTransportMask:(AJNTransportMask) transport namePrefix:(NSString *)namePrefix;

/**
 * Called by the bus when the ownership of any well-known name changes.
 *
 * @param name        The well-known name that has changed.
 * @param newOwner       The unique name that now owns the name or NULL if the there is no new owner.
 * @param previousOwner  The unique name that previously owned the name or NULL if there was no previous owner.
 */
- (void)nameOwnerChanged:(NSString *)name to:(NSString *)newOwner from:(NSString *)previousOwner;

/**
 * Called when a BusAttachment this listener is registered with is stopping.
 */
- (void)busWillStop;

/**
 * Called when a BusAttachment this listener is registered with is has become disconnected from
 * the bus.
 */
- (void)busDidDisconnect;

@end
