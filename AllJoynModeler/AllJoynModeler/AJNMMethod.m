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

#import "AJNMMethod.h"
#import "AJNMArgument.h"

@interface AJNMMethod()

@property (nonatomic, readonly) int outArgumentCount;
@property (nonatomic, readonly) int inArgumentCount;

@end

@implementation AJNMMethod

@synthesize arguments = _arguments;

- (int)outArgumentCount
{
    int count = 0;
    for (AJNMArgument *anArgument in self.arguments) {
        if (anArgument.direction == kAJNMArgumentDirectionOut) {
            count++;
        }
    }
    return count;
}

- (int)inArgumentCount
{
    int count = 0;
    for (AJNMArgument *anArgument in self.arguments) {
        if (anArgument.direction == kAJNMArgumentDirectionIn) {
            count++;
        }
    }
    return count;
}

- (NSMutableArray *)arguments
{
    if (_arguments == nil) {
        _arguments = [[NSMutableArray alloc] init];
    }
    return _arguments;
}

- (NSString *)descriptiveName 
{
    return self.selectorString;
}

- (NSString *)selectorString
{
    NSMutableString *selectorString = [[NSMutableString alloc] init];
    int outArgCount = self.outArgumentCount;
    for (AJNMArgument *anArgument in self.arguments) {
        if (anArgument.direction != kAJNMArgumentDirectionIn && outArgCount <= 1) {
            continue;
        }
        [selectorString appendFormat:@"%@", anArgument.descriptiveName];
    }
    if (selectorString.length == 0) {
        selectorString = [self.name mutableCopy];
    }
    return selectorString;
}

@end
