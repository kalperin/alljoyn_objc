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
 * Transports mask
 */
typedef uint16_t AJNTransportMask;

/**< no transports */
extern const AJNTransportMask kAJNTransportMaskNone;        

/**< ANY transport */
extern const AJNTransportMask kAJNTransportMaskAny;         

/**< Local (same device) transport */
extern const AJNTransportMask kAJNTransportMaskLocal;       

/**< Bluetooth transport */
extern const AJNTransportMask kAJNTransportMaskBluetooth;   

/**< Wireless local-area network transport */
extern const AJNTransportMask kAJNTransportMaskWLAN;        

/**< Wireless wide-area network transport */
extern const AJNTransportMask kAJNTransportMaskWWAN;        

/**< Wired local-area network transport */
extern const AJNTransportMask kAJNTransportMaskLAN;         
    

