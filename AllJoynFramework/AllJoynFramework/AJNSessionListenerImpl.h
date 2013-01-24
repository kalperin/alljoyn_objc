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

#import <alljoyn/Session.h>
#import <alljoyn/SessionListener.h>
#import <alljoyn/TransportMask.h>

#import "AJNBusAttachment.h"
#import "AJNSessionListener.h"

class AJNSessionListenerImpl : public ajn::SessionListener {
  protected:
    __weak AJNBusAttachment* busAttachment;

    /**
     * Objective C delegate called when one of the below virtual functions
     * is called.
     */
    __weak id<AJNSessionListener> m_delegate;

  public:
    /**
     * Constructor for the AJN session listener implementation.
     *
     * @param aBusAttachment    Objective C bus attachment wrapper object.
     * @param aDelegate         Objective C delegate called when one of the below virtual functions is called.
     */
    AJNSessionListenerImpl(AJNBusAttachment* aBusAttachment, id<AJNSessionListener> aDelegate);

    /**
     * Virtual destructor for derivable class.
     */
    virtual ~AJNSessionListenerImpl();

    /**
     * Called by the bus when an existing session becomes disconnected.
     *
     * @param sessionId     Id of session that was lost.
     */
    virtual void SessionLost(ajn::SessionId sessionId);

    /**
     * Called by the bus when a member of a multipoint session is added.
     *
     * @param sessionId     Id of session whose member(s) changed.
     * @param uniqueName    Unique name of member who was added.
     */
    virtual void SessionMemberAdded(ajn::SessionId sessionId, const char* uniqueName);

    /**
     * Called by the bus when a member of a multipoint session is removed.
     *
     * @param sessionId     Id of session whose member(s) changed.
     * @param uniqueName    Unique name of member who was removed.
     */
    virtual void SessionMemberRemoved(ajn::SessionId sessionId, const char* uniqueName);

    /**
     * Accessor for Objective-C delegate.
     *
     * return delegate         The Objective-C delegate called to handle the above event methods.
     */
    id<AJNSessionListener> getDelegate();

    /**
     * Mutator for Objective-C delegate.
     *
     * @param delegate    The Objective-C delegate called to handle the above event methods.
     */
    void setDelegate(id<AJNSessionListener> delegate);
};

inline id<AJNSessionListener> AJNSessionListenerImpl::getDelegate()
{
    return m_delegate;
}

inline void AJNSessionListenerImpl::setDelegate(id<AJNSessionListener> delegate)
{
    m_delegate = delegate;
}
