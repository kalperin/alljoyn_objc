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

#import "MyBasicSampleObject+AllJoyn.h"

@implementation MyBasicSampleObject (AllJoyn)

@dynamic handle;

- (NSString*)concatenateString:(NSString *)string1 withString:(NSString *)string2
{
    [self.delegate didReceiveStatusUpdateMessage:[NSString stringWithFormat:@"MyBasicSampleObject::concatenateString:withString: was called with \"%@\" and \"%@\".\n", string1, string2]];
    return [NSString stringWithFormat:@"%@%@", string1, string2];
}

@end
