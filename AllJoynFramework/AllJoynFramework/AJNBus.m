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

#import "AJNBus.h"

/**< RequestName input flag: Allow others to take ownership of this name */
const AJNBusNameFlag kAJNBusNameFlagAllowReplacement = 0x01;     
/**< RequestName input flag: Attempt to take ownership of name if already taken */
const AJNBusNameFlag kAJNBusNameFlagReplaceExisting  = 0x02;     
/**< RequestName input flag: Fail if name cannot be immediately obtained */
const AJNBusNameFlag kAJNBusNameFlagDoNotQueue       = 0x04;     
