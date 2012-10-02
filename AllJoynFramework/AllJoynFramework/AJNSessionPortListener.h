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
 * app of session related events.
 */
@protocol AJNSessionPortListener <NSObject>

@required

/**
 * Accept or reject an incoming JoinSession request. The session does not exist until this
 * after this function returns.
 *
 * This callback is only used by session creators. Therefore it is only called on listeners
 * passed to BusAttachment::BindSessionPort.
 *
 * @param joiner            Unique name of potential joiner.
 * @param sessionPort       Session port that was joined.
 * @param options           Session options requested by the joiner.
 * @return   Return true if JoinSession request is accepted. false if rejected.
 */
- (BOOL)shouldAcceptSessionJoinerNamed:(NSString*)joiner onSessionPort:(AJNSessionPort) sessionPort withSessionOptions:(AJNSessionOptions*)options;

@optional

/**
 * Called by the bus when a session has been successfully joined. The session is now fully up.
 *
 * This callback is only used by session creators. Therefore it is only called on listeners
 * passed to AJNBusAttachment::bindSessionOnPort.
 *
 * @param joiner         Unique name of the joiner.
 * @param sessionId      Id of session.
 * @param sessionPort    Session port that was joined.
 */
- (void)didJoin:(NSString*)joiner inSessionWithId:(AJNSessionId) sessionId onSessionPort:(AJNSessionPort)sessionPort;

@end
