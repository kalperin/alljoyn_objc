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

#import "PerformanceStatistics.h"

@interface PerformanceStatistics()

@property (nonatomic) int bitsPerByte;
@property (nonatomic) int totalDataSize;
@property (nonatomic) int packetSize;
@property (nonatomic) int packetTransfersCompleted;
@property (nonatomic) int totalPacketTransfersExpected;
@property (nonatomic) int refreshUIInterval;

@property (nonatomic, strong) NSDate *discoveryStartTime;
@property (nonatomic, strong) NSDate *discoveryEndTime;
@property (nonatomic) NSTimeInterval discoveryTimespan;

@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *endTime;
@property (nonatomic) NSTimeInterval timespan;

@property (nonatomic) int successfulSignalsCount;
@property (nonatomic) int successfulMethodCallsCount;

@end

@implementation PerformanceStatistics

- (double)megaBytesTransferred
{
    return self.packetSize * self.packetTransfersCompleted / 1024.0 / 1024.0;
}

- (double)throughputInMegaBitsPerSecond
{
    return self.packetSize * self.packetTransfersCompleted * self.bitsPerByte / 1000000.0 / self.timespan;
}

- (NSTimeInterval)timeRequiredToCompleteDiscoveryOfService
{
    return self.discoveryTimespan;
}

- (NSTimeInterval)timeRequiredToCompleteAllPacketTransfers
{
    return self.timespan;
}

- (void)markDiscoveryStartTime
{
    self.discoveryStartTime = [NSDate date];
}

- (void)markDiscoveryEndTime
{
    self.discoveryEndTime = [NSDate date];
    self.discoveryTimespan = [self.discoveryEndTime timeIntervalSinceDate:self.discoveryStartTime];
}

- (void)markTransferStartTime
{
    self.startTime = [NSDate date];
}

- (void)markTransferEndTime
{
    self.endTime = [NSDate date];
    self.timespan = [self.endTime timeIntervalSinceDate:self.startTime];
}

- (void)resetStatisticsWithPacketSize:(int)kilobitsPerPacket
{
    self.bitsPerByte = 8;
    self.totalDataSize = 100 * 1000 * 1000 / self.bitsPerByte;
    self.packetSize = kilobitsPerPacket * 1000 / self.bitsPerByte;
    self.packetTransfersCompleted = self.totalDataSize / self.packetSize;
    self.totalPacketTransfersExpected = self.packetTransfersCompleted + 1;
    if (self.packetTransfersCompleted > 100) {
        self.refreshUIInterval = self.packetTransfersCompleted / 100;
    }
    else {
        self.refreshUIInterval = 2;
    }
    self.discoveryStartTime = nil;
    self.discoveryEndTime = nil;
    self.discoveryTimespan = 0;
    self.startTime = nil;
    self.endTime = nil;
    self.timespan = 0;
    self.successfulSignalsCount = 0;
    self.successfulMethodCallsCount = 0;
    self.packetTransfersCompleted = 0;
}

- (BOOL)shouldRefreshUserInterfaceForPacketAtIndex:(int)packetIndex
{
    return (packetIndex % self.refreshUIInterval) == 0 || packetIndex == self.totalPacketTransfersExpected - 1;
}

- (void)incrementSuccessfulMethodCallsCount
{
    self.packetTransfersCompleted++;
    self.successfulMethodCallsCount++;
}

- (void)incrementSuccessfulSignalTransmissionsCount
{
    self.packetTransfersCompleted++;
    self.successfulSignalsCount++;
}

@end
