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

#import <alljoyn/Status.h>
#import "AJNHandle.h"

/**
 * An application can provide a key store listener to override the default key store Load and Store
 * behavior. This will override the default key store behavior.
 */
@protocol AJNKeyStoreListener <NSObject>

@required

/**
 * This method is called when a key store needs to be loaded.
 * @remark The application must call <tt>#PutKeys</tt> to put the new key store data into the
 * internal key store.
 *
 * @param keyStore   Reference to the KeyStore to be loaded.
 *
 * @return  - ER_OK if the load request was satisfied
 *          - An error status otherwise
 *
 */
- (QStatus)load:(AJNHandle)keyStore;

/**
 * This method is called when a key store needs to be stored.
 * @remark The application must call <tt>#GetKeys</tt> to obtain the key data to be stored.
 *
 * @param keyStore   Reference to the KeyStore to be stored.
 *
 * @return  - ER_OK if the store request was satisfied
 *          - An error status otherwise
 */
- (QStatus)store:(AJNHandle)keyStore;

/**
 * Get the current keys from the key store as an encrypted byte string.
 *
 * @param keyStore  The keyStore to get from. This is the keystore indicated in the StoreRequest call.
 * @param sink      The byte string to write the keys to.
 * @return  - ER_OK if successful
 *          - An error status otherwise
 */
- (QStatus)getKeys:(AJNHandle) keyStore sink:(NSString *)sink;

/**
 * Put keys into the key store from an encrypted byte string.
 *
 * @param keyStore  The keyStore to put to. This is the keystore indicated in the LoadRequest call.
 * @param source    The byte string containing the encrypted key store contents.
 * @param password  The password required to decrypt the key data
 *
 * @return  - ER_OK if successful
 *          - An error status otherwise
 *
 */
- (QStatus)putKeys:(AJNHandle) keyStore source:(NSString *)source password:(NSString *)password;


@end
