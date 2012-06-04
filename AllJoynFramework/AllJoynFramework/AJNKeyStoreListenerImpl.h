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

#import <alljoyn/KeystoreListener.h>
#import "AJNKeyStoreListener.h"

class AJNKeyStoreListenerImpl : public ajn::KeyStoreListener
{
protected:
    
    /**
     * Objective C delegate called when one of the below virtual functions
     * is called.
     */
    id<AJNKeyStoreListener> m_delegate;
    
public:
    
    /**
     * Constructor for the AJN key store handler implementation.
     *
     * @param aDelegate         Objective C delegate called when one of the below virtual functions is called.     
     */    
    AJNKeyStoreListenerImpl(id<AJNKeyStoreListener> aDelegate);

    /**
     * Virtual destructor for derivable class.
     */
    virtual ~AJNKeyStoreListenerImpl();
    
    /**
     * This method is called when a key store needs to be loaded.
     * @remark The application must call <tt>#PutKeys</tt> to put the new key store data into the
     * internal key store.
     *
     * @param keyStore   Reference to the KeyStore to be loaded.
     *
     * @return
     *      - #ER_OK if the load request was satisfied
     *      - An error status otherwise
     *
     */
    QStatus LoadRequest(ajn::KeyStore& keyStore);
    
    
    /**
     * This method is called when a key store needs to be stored.
     * @remark The application must call <tt>#GetKeys</tt> to obtain the key data to be stored.
     *
     * @param keyStore   Reference to the KeyStore to be stored.
     *
     * @return
     *      - #ER_OK if the store request was satisfied
     *      - An error status otherwise
     */
    QStatus StoreRequest(ajn::KeyStore& keyStore);
    

    /**
     * Accessor for Objective-C delegate.
     *
     * return delegate         The Objective-C delegate called to handle the above event methods.
     */
    id<AJNKeyStoreListener> getDelegate();
    
    
    /**
     * Mutator for Objective-C delegate.
     *
     * @param delegate    The Objective-C delegate called to handle the above event methods.
     */
    void setDelegate(id<AJNKeyStoreListener> delegate);
};

// inline methods
//

inline id<AJNKeyStoreListener> AJNKeyStoreListenerImpl::getDelegate()
{
    return m_delegate;
}

inline void AJNKeyStoreListenerImpl::setDelegate(id<AJNKeyStoreListener> delegate)
{
    m_delegate = delegate;
}
