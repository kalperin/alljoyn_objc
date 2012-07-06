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

#import "AJNObject.h"

@interface AJNObject()

/**
 * Flag indicating whether or not the object pointed to by handle should be deleted when an instance of this class is deallocated.
 */
@property (nonatomic) BOOL shouldDeleteHandleOnDealloc;

@end

@implementation AJNObject

@synthesize handle = _handle;
@synthesize shouldDeleteHandleOnDealloc = _shouldDeleteHandleOnDealloc;

- (id)initWithHandle:(AJNHandle)handle
{
    self = [super init];
    if (self) {
        self.handle = handle;
        self.shouldDeleteHandleOnDealloc = NO;
    }
    return self;
}

- (id)initWithHandle:(AJNHandle)handle shouldDeleteHandleOnDealloc:(BOOL)deletionFlag
{
    self = [super init];
    if (self) {
        self.handle = handle;
        self.shouldDeleteHandleOnDealloc = deletionFlag;
    }
    return self;
}

@end
