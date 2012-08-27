//
//  BusStressManager.m
//  Bus Stress
//
//  Created by Guest on 8/27/12.
//  Copyright (c) 2012 Qualcomm Innovation Center, Inc. All rights reserved.
//

#import "BusStressManager.h"
#import "AJNBusAttachment.h"
#import "AJNBusObject.h"
#import "AJNBusObjectImpl.h"


@interface AJNBusAttachment(Private)

- (ajn::BusAttachment*)busAttachment;

@end


@interface StressOperation : NSOperation

@property (nonatomic) BOOL shouldDeleteBusAttachment;

@end

@implementation StressOperation

@synthesize shouldDeleteBusAttachment = _shouldDeleteBusAttachment;

- (void)main
{
    NSString *name = [NSString stringWithFormat:@"bastress%d", rand()];
    AJNBusAttachment *bus = [[AJNBusAttachment alloc] initWithApplicationName:name allowRemoteMessages:YES];
    QStatus status =  [bus start];
    status = [bus connectWithArguments:@"null:"];
    if (ER_OK != status) {
        NSLog(@"Bus connect failed.");
    }
    
    name = [NSString stringWithFormat:@"org.alljoyn.test.bastress.stressrun%d", rand()];
    status = [bus requestWellKnownName:name withFlags:kAJNBusNameFlagReplaceExisting | kAJNBusNameFlagDoNotQueue];
    if (ER_OK != status) {
        NSLog(@"Request for name failed (%@)", name);
    }
    
    status = [bus advertiseName:name withTransportMask:kAJNTransportMaskAny];
    if (ER_OK != status) {
        NSLog(@"Could not advertise (%@)", name);
    }
    
    NSString *path = @"/org/cool";
    AJNBusObject *busObject = [[AJNBusObject alloc] initWithBusAttachment:bus onPath:path];
    AJNBusObjectImpl *busObjectImpl = new AJNBusObjectImpl(*bus.busAttachment, [path UTF8String], busObject);
    
    busObject.handle = busObjectImpl;
    
    [bus registerBusObject:busObject];
    [bus unregisterBusObject:busObject];
    
    if (self.shouldDeleteBusAttachment) {
        [bus destroy];
        bus = nil;
    }    
}

@end

@implementation BusStressManager

+ (void)runStress:(NSInteger)iterations threadCount:(NSInteger)threadCount deleteBusFlag:(BOOL)shouldDeleteBusAttachment stopThreadsFlag:(BOOL)stopThreads delegate:(id<BusStressManagerDelegate>)delegate
{
    dispatch_queue_t queue = dispatch_queue_create("bastress", NULL);
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < iterations; i++) {
            NSOperationQueue *queue = [[NSOperationQueue alloc] init];
            
            [queue setMaxConcurrentOperationCount:threadCount];
            
            for (NSInteger i = 0; i < threadCount; i++) {
                StressOperation *stressOperation = [[StressOperation alloc] init];
                stressOperation.shouldDeleteBusAttachment = shouldDeleteBusAttachment;
                
                [queue addOperation:stressOperation];
            }
            
            if (stopThreads) {
                sleep(rand() % 4);
                [queue cancelAllOperations];
            }
            
            [queue waitUntilAllOperationsAreFinished];
            
            NSLog(@"Threads completed for iteration %d", i);
            
            [delegate didCompleteIteration:i totalIterations:iterations];
        }

    });
    dispatch_release(queue);
}

@end
