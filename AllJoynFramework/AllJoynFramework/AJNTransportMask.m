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

#import "AJNTransportMask.h"

const AJNTransportMask kAJNTransportMaskNone      = 0x0000;   /**< no transports */
const AJNTransportMask kAJNTransportMaskAny       = 0xFFFF;   /**< ANY transport */
const AJNTransportMask kAJNTransportMaskLocal     = 0x0001;   /**< Local (same device) transport */
const AJNTransportMask kAJNTransportMaskBluetooth = 0x0002;   /**< Bluetooth transport */
const AJNTransportMask kAJNTransportMaskWLAN      = 0x0004;   /**< Wireless local-area network transport */
const AJNTransportMask kAJNTransportMaskWWAN      = 0x0008;   /**< Wireless wide-area network transport */
const AJNTransportMask kAJNTransportMaskLAN       = 0x0010;   /**< Wired local-area network transport */
