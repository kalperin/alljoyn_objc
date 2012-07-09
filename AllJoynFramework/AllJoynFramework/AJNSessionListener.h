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
#import "AJNSessionOptions.h"

/**
 * Protocol implemented by AllJoyn apps and called by AllJoyn to inform
 * the app of session related events.
 */
@protocol AJNSessionListener <NSObject>

@optional

/**
 * Called by the bus when an existing session becomes disconnected.
 *
 * @param sessionId     Id of session that was lost.
 */
- (void)sessionWasLost:(AJNSessionId)sessionId;

/**
 * Called by the bus when a member of a multipoint session is added.
 *
 * @param memberName    Unique name of member who was added. 
 * @param sessionId     Id of session whose member(s) changed.
 */
- (void)didAddMemberNamed:(NSString*)memberName toSession:(AJNSessionId)sessionId;

/**
 * Called by the bus when a member of a multipoint session is removed.
 *
 * @param memberName    Unique name of member who was added. 
 * @param sessionId     Id of session whose member(s) changed.
 */
- (void)didRemoveMemberNamed:(NSString*)memberName fromSession:(AJNSessionId)sessionId;

@end
