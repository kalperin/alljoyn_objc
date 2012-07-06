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
 * Type definition for the AJNHandle, which is used to refer to C++ API objects.
 */
typedef void* AJNHandle;

/**
 * The objective-c base class that serves as a wrapper for a C++ API class. The instance
 * of the C++ API object is maintained in the handle property.
 */
@protocol AJNHandle <NSObject>

/**
 * Holds a pointer to a C++ API object.
 */
@property (nonatomic, assign) AJNHandle handle;

@end
