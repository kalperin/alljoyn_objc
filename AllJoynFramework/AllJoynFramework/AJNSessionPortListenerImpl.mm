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

#import "AJNSessionPortListenerImpl.h"

using namespace ajn;

const char * AJNSessionPortListenerImpl::AJN_SESSION_PORT_LISTENER_DISPATCH_QUEUE_NAME = "org.alljoyn.session-port-listener.queue";

/**
 * Constructor for the AJN session port listener implementation.
 *
 * @param aBusAttachment    Objective C bus attachment wrapper object.
 * @param aDelegate         Objective C delegate called when one of the below virtual functions is called.     
 */    
AJNSessionPortListenerImpl::AJNSessionPortListenerImpl(AJNBusAttachment *aBusAttachment, id<AJNSessionPortListener> aDelegate) : busAttachment(aBusAttachment), m_delegate(aDelegate)
{

}

/**
 * Virtual destructor for derivable class.
 */
AJNSessionPortListenerImpl::~AJNSessionPortListenerImpl()
{
    busAttachment = nil;
    m_delegate = nil;
}

/**
 * Accept or reject an incoming JoinSession request. The session does not exist until this
 * after this function returns.
 *
 * This callback is only used by session creators. Therefore it is only called on listeners
 * passed to BusAttachment::BindSessionPort.
 *
 * @param sessionPort    Session port that was joined.
 * @param joiner         Unique name of potential joiner.
 * @param opts           Session options requested by the joiner.
 * @return   Return true if JoinSession request is accepted. false if rejected.
 */
bool AJNSessionPortListenerImpl::AcceptSessionJoiner(SessionPort sessionPort, const char* joiner, const SessionOpts& opts)
{
    NSLog(@"AJNSessionPortListenerImpl::AcceptSessionJoiner(port:%u, joiner:%s)", sessionPort, joiner);
    bool result = false;
    NSString *aJoiner = [NSString stringWithCString:joiner encoding:NSUTF8StringEncoding];
    @autoreleasepool {
        AJNSessionOptions *options = [[AJNSessionOptions alloc] initWithHandle:(AJNHandle)&opts];
        result = [m_delegate shouldAcceptSessionJoinerNamed:aJoiner onSessionPort:sessionPort withSessionOptions:options] == YES;
    }
    return result;
}

/**
 * Called by the bus when a session has been successfully joined. The session is now fully up.
 *
 * This callback is only used by session creators. Therefore it is only called on listeners
 * passed to BusAttachment::BindSessionPort.
 *
 * @param sessionPort    Session port that was joined.
 * @param id             Id of session.
 * @param joiner         Unique name of the joiner.
 */
void AJNSessionPortListenerImpl::SessionJoined(SessionPort sessionPort, SessionId sessionId, const char* joiner)
{
    NSLog(@"AJNSessionPortListenerImpl::SessionJoined(port:%u, sessionId:%u, joiner:%s)", sessionPort, sessionId, joiner);
    if ([m_delegate respondsToSelector:@selector(didJoin:inSessionWithId:onSessionPort:)]) {    
        @autoreleasepool {
            NSString *aJoiner = [NSString stringWithCString:joiner encoding:NSUTF8StringEncoding];
            __block id<AJNSessionPortListener> theDelegate = m_delegate;                                
            dispatch_queue_t queue = dispatch_get_main_queue();
            dispatch_async(queue, ^{
                    [theDelegate didJoin:aJoiner inSessionWithId:sessionId onSessionPort:sessionPort];
            });
        }
    }
}
