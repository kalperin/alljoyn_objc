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

#import "AJNCConstants.h"

const AJNSessionPort kServicePort = 27;
NSString * const kServicePath = @"/chatService";
NSString * const kServiceName = @"org.alljoyn.bus.samples.chat.";
NSString * const kInterfaceName = @"org.alljoyn.bus.samples.chat";
NSString * const kMethodName = @"Chat";
NSString * const kAppName = @"chat";
AJNMessageFlag gMessageFlags = 0x0;
