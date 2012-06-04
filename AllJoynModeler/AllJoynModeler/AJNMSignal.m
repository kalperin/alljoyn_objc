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

#import "AJNMSignal.h"
#import "AJNMArgument.h"

@implementation AJNMSignal

@synthesize arguments = _arguments;

- (NSMutableArray *)arguments
{
    if (_arguments == nil) {
        _arguments = [[NSMutableArray alloc] init];
    }
    return _arguments;
}

- (NSString *)descriptiveName
{
    NSMutableString *selectorString = [[NSMutableString alloc] init];
    for (AJNMArgument *anArgument in self.arguments) {
        [selectorString appendFormat:@"%@", anArgument.descriptiveName];
    }
    if (selectorString.length == 0) {
        selectorString = [self.name mutableCopy];
    }
    return selectorString;    
}

@end
