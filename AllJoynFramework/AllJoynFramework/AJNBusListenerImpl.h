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
#import <alljoyn/BusListener.h>
#import <alljoyn/TransportMask.h>
#import "AJNBusListener.h"
#import "AJNBusAttachment.h"

class AJNBusListenerImpl : public ajn::BusListener
{
protected:
    AJNBusAttachment *busAttachment;

    /**
     * Objective C delegate called when one of the below virtual functions
     * is called.
     */
    id<AJNBusListener> m_delegate;

public:

    /**
     * Constructor for the AJN bus listener implementation.
     *
     * @param aBusAttachment    Objective C bus attachment wrapper object.
     * @param aDelegate         Objective C delegate called when one of the below virtual functions is called.     
     */    
    AJNBusListenerImpl(AJNBusAttachment *aBusAttachment, id<AJNBusListener> aDelegate);
    
    /**
     * Virtual destructor for derivable class.
     */
    virtual ~AJNBusListenerImpl();
    
    /**
     * Called by the bus when the listener is registered. This give the listener implementation the
     * opportunity to save a reference to the bus.
     *
     * @param bus  The bus the listener is registered with.
     */
    virtual void ListenerRegistered(ajn::BusAttachment* bus);
    
    /**
     * Called by the bus when the listener is unregistered.
     */
    virtual void ListenerUnregistered();
    
    /**
     * Called by the bus when an external bus is discovered that is advertising a well-known name
     * that this attachment has registered interest in via a DBus call to org.alljoyn.Bus.FindAdvertisedName
     *
     * @param name         A well known name that the remote bus is advertising.
     * @param transport    Transport that received the advertisement.
     * @param namePrefix   The well-known name prefix used in call to FindAdvertisedName that triggered this callback.
     */
    virtual void FoundAdvertisedName(const char* name, ajn::TransportMask transport, const char* namePrefix);
    
    /**
     * Called by the bus when an advertisement previously reported through FoundName has become unavailable.
     *
     * @param name         A well known name that the remote bus is advertising that is of interest to this attachment.
     * @param transport    Transport that stopped receiving the given advertised name.
     * @param namePrefix   The well-known name prefix that was used in a call to FindAdvertisedName that triggered this callback.
     */
    virtual void LostAdvertisedName(const char* name, ajn::TransportMask transport, const char* namePrefix);
    
    /**
     * Called by the bus when the ownership of any well-known name changes.
     *
     * @param busName        The well-known name that has changed.
     * @param previousOwner  The unique name that previously owned the name or NULL if there was no previous owner.
     * @param newOwner       The unique name that now owns the name or NULL if the there is no new owner.
     */
    virtual void NameOwnerChanged(const char* busName, const char* previousOwner, const char* newOwner);
    
    /**
     * Called when a BusAttachment this listener is registered with is stopping.
     */
    virtual void BusStopping();
    
    /**
     * Called when a BusAttachment this listener is registered with is has become disconnected from
     * the bus.
     */
    virtual void BusDisconnected();
    
    /**
     * Accessor for Objective-C delegate.
     *
     * return delegate         The Objective-C delegate called to handle the above event methods.
     */
    id<AJNBusListener> getDelegate();
    
    /**
     * Mutator for Objective-C delegate.
     *
     * @param delegate    The Objective-C delegate called to handle the above event methods.
     */
    void setDelegate(id<AJNBusListener> delegate);
};

// inline methods
//

inline id<AJNBusListener> AJNBusListenerImpl::getDelegate()
{
    return m_delegate;
}

inline void AJNBusListenerImpl::setDelegate(id<AJNBusListener> delegate)
{
    m_delegate = delegate;
}
