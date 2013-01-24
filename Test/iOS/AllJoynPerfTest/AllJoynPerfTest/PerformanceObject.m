////////////////////////////////////////////////////////////////////////////////
// Copyright 2013, Qualcomm Innovation Center, Inc.
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
////////////////////////////////////////////////////////////////////////////////
//
//  ALLJOYN MODELING TOOL - GENERATED CODE
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
//  PerformanceObject.m
//
////////////////////////////////////////////////////////////////////////////////

#import "PerformanceObject.h"
#import "AJNMessageArgument.h"

////////////////////////////////////////////////////////////////////////////////
//
//  Objective-C Bus Object implementation for PerformanceObject
//
////////////////////////////////////////////////////////////////////////////////

@implementation PerformanceObject

- (BOOL)checkPacketAtIndex:(NSNumber*)packetIndex payLoad:(AJNMessageArgument*)byteArray packetSize:(NSNumber*)packetSize message:(AJNMessage *)methodCallMessage
{
    uint8_t *buffer;
    size_t bufferLength;
    [byteArray value:@"ay", &bufferLength, &buffer];

    PerformanceStatistics *performanceStatistics = self.viewController.performanceStatistics;
    [performanceStatistics incrementSuccessfulMethodCallsCount];
    
    if (performanceStatistics.packetTransfersCompleted == 1) {
        // this is the first time we have received a packet for this session
        [performanceStatistics markTransferStartTime];
    }
    else if(performanceStatistics.totalPacketTransfersExpected == [packetIndex intValue] + 1) {
        [performanceStatistics markTransferEndTime];
        dispatch_async(dispatch_get_main_queue(), ^{
            float progress = performanceStatistics.packetTransfersCompleted / (float)performanceStatistics.totalPacketTransfersExpected;
            [self.viewController.progressView setProgress:progress];
            [self.viewController displayPerformanceStatistics];
            NSLog(@"Updating UI for packet at index %@ progress %f", packetIndex, progress);
        });
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.viewController didTouchStartButton:self];
        });
    }
    else if([performanceStatistics shouldRefreshUserInterfaceForPacketAtIndex:[packetIndex intValue]]) {
        [performanceStatistics markTransferEndTime];        
        dispatch_async(dispatch_get_main_queue(), ^{
            float progress = performanceStatistics.packetTransfersCompleted / (float)performanceStatistics.totalPacketTransfersExpected;
            [self.viewController.progressView setProgress:progress];
            [self.viewController displayPerformanceStatistics];
            NSLog(@"Updating UI for packet at index %@ progress %f", packetIndex, progress);
        });
    }

    return buffer != NULL && bufferLength == [packetSize longValue];
}


@end

////////////////////////////////////////////////////////////////////////////////
