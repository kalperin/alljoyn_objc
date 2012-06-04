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

#import "AJNMInterface.h"

@implementation AJNMInterface

@synthesize properties = _properties;
@synthesize signals = _signals;
@synthesize methods = _methods;

- (NSMutableArray *)properties
{
    if (_properties == nil) {
        _properties = [[NSMutableArray alloc] init];
    }
    return _properties;
}

- (NSMutableArray *)signals
{
    if (_signals == nil) {
        _signals = [[NSMutableArray alloc] init];
    }
    return _signals;
}

- (NSMutableArray *)methods
{
    if (_methods == nil) {
        _methods = [[NSMutableArray alloc] init];
    }
    return _methods;
}

@end
