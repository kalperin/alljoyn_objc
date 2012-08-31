//
//  BusStressManager.h
//  Bus Stress
//
//  Created by Guest on 8/27/12.
//  Copyright (c) 2012 Qualcomm Innovation Center, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _BusStressManagerOperationMode
{
    kBusStressManagerOperationModeNone = 0,
    kBusStressManagerOperationModeClient = 1,
    kBusStressManagerOperationModeService = 2
} BusStressManagerOperationMode;

@protocol BusStressManagerDelegate <NSObject>

- (void)didCompleteIteration:(NSInteger)iterationNumber totalIterations:(NSInteger)totalInterations;

@end

@interface BusStressManager : NSObject

+ (void)runStress:(NSInteger)iterations threadCount:(NSInteger)threadCount deleteBusFlag:(BOOL)shouldDeleteBusAttachment stopThreadsFlag:(BOOL)stopThreads operationMode:(BusStressManagerOperationMode)mode delegate:(id<BusStressManagerDelegate>)delegate;

+ (void)stopStress;

@end
