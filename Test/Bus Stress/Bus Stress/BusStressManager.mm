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
#import "AJNBasicObject.h"
#import "BasicObject.h"

@interface AJNBusAttachment(Private)

- (ajn::BusAttachment*)busAttachment;

@end

@interface StressOperation : NSOperation<BasicStringsDelegateSignalHandler>

@property (nonatomic, strong) AJNBusAttachment *bus;
@property (nonatomic, strong) BasicObject *busObject;
@property (nonatomic) BOOL shouldDeleteBusAttachment;

- (void)setup;
- (void)tearDown;

@end

@interface ClientStressOperation : StressOperation<AJNBusListener, AJNSessionListener>

@property (nonatomic, strong) NSCondition *joinedSessionCondition;
@property (nonatomic) AJNSessionId sessionId;
@property (nonatomic, strong) NSString *foundServiceName;
@property (nonatomic, strong) BasicObjectProxy *basicObjectProxy;

@end

@interface ServiceStressOperation : StressOperation<AJNBusListener, AJNSessionListener, AJNSessionPortListener>

@property (nonatomic, strong) NSCondition *joinedSessionCondition;

@end

@implementation ClientStressOperation

@synthesize joinedSessionCondition = _joinedSessionCondition;
@synthesize sessionId = _sessionId;
@synthesize foundServiceName = _foundServiceName;
@synthesize basicObjectProxy = _basicObjectProxy;

- (void)main
{
    [self setup];
    
    self.joinedSessionCondition = [[NSCondition alloc] init];
    [self.joinedSessionCondition lock];
    
    [self.bus registerBusListener:self];
    
    [self.bus findAdvertisedName:@"org.alljoyn.test.bastress.service."];
    
    if ([self.joinedSessionCondition waitUntilDate:[NSDate dateWithTimeIntervalSinceNow:5]]) {
    
        [self.joinedSessionCondition unlock];
        
        self.basicObjectProxy = [[BasicObjectProxy alloc] initWithBusAttachment:self.bus serviceName:self.foundServiceName objectPath:@"/org/cool" sessionId:self.sessionId];
        
        NSString *result = [self.basicObjectProxy concatenateString:@"Code " withString:@"Monkies!!!!!!!"];
        
        NSLog(@"%@ concatenated string. %@", [result compare:@"Code Monkies!!!!!!!"] == NSOrderedSame ? @"Successfully":@"Unsuccessfully", result);
        
        self.basicObjectProxy = nil;
    }
    
    [self tearDown];
}

#pragma mark - AJNBusListener delegate methods

- (void)didFindAdvertisedName:(NSString*)name withTransportMask:(AJNTransportMask)transport namePrefix:(NSString*)namePrefix
{
    NSLog(@"AJNBusListener::didFindAdvertisedName:%@ withTransportMask:%u namePrefix:%@", name, transport, namePrefix);
    
    [self.bus enableConcurrentCallbacks];
    
    self.sessionId = [self.bus joinSessionWithName:name onPort:999 withDelegate:self options:[[AJNSessionOptions alloc] initWithTrafficType:kAJNTrafficMessages supportsMultipoint:YES proximity:kAJNProximityAny transportMask:kAJNTransportMaskAny]];
    self.foundServiceName = name;
    
    NSLog(@"Client joined session %d", self.sessionId);
    
    [self.joinedSessionCondition signal];

}


@end

@implementation ServiceStressOperation

@synthesize joinedSessionCondition = _joinedSessionCondition;

- (void)main
{
    [self setup];
    
    self.joinedSessionCondition = [[NSCondition alloc] init];
    [self.joinedSessionCondition lock];
    
    [self.bus registerBusListener:self];
    
    NSString *name = [NSString stringWithFormat:@"org.alljoyn.test.bastress.service.i%d", rand()];
    QStatus status = [self.bus requestWellKnownName:name withFlags:kAJNBusNameFlagReplaceExisting | kAJNBusNameFlagDoNotQueue];
    if (ER_OK != status) {
        NSLog(@"Request for name failed (%@)", name);
    }
    
    status = [self.bus advertiseName:name withTransportMask:kAJNTransportMaskAny];
    if (ER_OK != status) {
        NSLog(@"Could not advertise (%@)", name);
    }
    
    NSString *path = @"/org/cool";
    self.busObject = [[BasicObject alloc] initWithBusAttachment:self.bus onPath:path];
    
    [self.bus registerBusObject:self.busObject];

    [self.joinedSessionCondition waitUntilDate:[NSDate dateWithTimeIntervalSinceNow:rand()%5]];
    
    [self.bus cancelAdvertisedName:name withTransportMask:kAJNTransportMaskAny];
    
    [self.bus unregisterBusObject:self.busObject];
    
    [self.joinedSessionCondition unlock];
    
    [self tearDown];
}

#pragma mark - AJNBusListener delegate methods

- (void)listenerDidRegisterWithBus:(AJNBusAttachment*)busAttachment
{
    NSLog(@"AJNBusListener::listenerDidRegisterWithBus:%@",busAttachment);
}

- (void)listenerDidUnregisterWithBus:(AJNBusAttachment*)busAttachment
{
    NSLog(@"AJNBusListener::listenerDidUnregisterWithBus:%@",busAttachment);
}

- (void)didFindAdvertisedName:(NSString*)name withTransportMask:(AJNTransportMask)transport namePrefix:(NSString*)namePrefix
{
    NSLog(@"AJNBusListener::didFindAdvertisedName:%@ withTransportMask:%u namePrefix:%@", name, transport, namePrefix);
}

- (void)didLoseAdvertisedName:(NSString*)name withTransportMask:(AJNTransportMask)transport namePrefix:(NSString*)namePrefix
{
    NSLog(@"AJNBusListener::listenerDidUnregisterWithBus:%@ withTransportMask:%u namePrefix:%@",name,transport,namePrefix);
}

- (void)nameOwnerChanged:(NSString*)name to:(NSString*)newOwner from:(NSString*)previousOwner
{
    NSLog(@"AJNBusListener::nameOwnerChanged:%@ to:%@ from:%@", name, newOwner, previousOwner);
}

- (void)busWillStop
{
    NSLog(@"AJNBusListener::busWillStop");
}

- (void)busDidDisconnect
{
    NSLog(@"AJNBusListener::busDidDisconnect");
}

#pragma mark - AJNSessionListener methods

- (void)sessionWasLost:(AJNSessionId)sessionId
{
    NSLog(@"AJNBusListener::sessionWasLost %u", sessionId);
}

- (void)didAddMemberNamed:(NSString*)memberName toSession:(AJNSessionId)sessionId
{
    NSLog(@"AJNBusListener::didAddMemberNamed:%@ toSession:%u", memberName, sessionId);
}

- (void)didRemoveMemberNamed:(NSString*)memberName fromSession:(AJNSessionId)sessionId
{
    NSLog(@"AJNBusListener::didRemoveMemberNamed:%@ fromSession:%u", memberName, sessionId);
}

#pragma mark - AJNSessionPortListener implementation

- (BOOL)shouldAcceptSessionJoinerNamed:(NSString*)joiner onSessionPort:(AJNSessionPort)sessionPort withSessionOptions:(AJNSessionOptions*)options
{
    NSLog(@"AJNSessionPortListener::shouldAcceptSessionJoinerNamed:%@ onSessionPort:%u withSessionOptions:", joiner, sessionPort);
    if (sessionPort == 999) {
        return YES;
    }
    return NO;
}

- (void)didJoin:(NSString*)joiner inSessionWithId:(AJNSessionId)sessionId onSessionPort:(AJNSessionPort)sessionPort
{
    NSLog(@"AJNSessionPortListener::didJoin:%@ inSessionWithId:%u onSessionPort:%u withSessionOptions:", joiner, sessionId, sessionPort);
}

@end

@implementation StressOperation

@synthesize bus = _bus;
@synthesize shouldDeleteBusAttachment = _shouldDeleteBusAttachment;
@synthesize handle = _handle;

- (void)setup
{
    NSString *name = [NSString stringWithFormat:@"bastress%d", rand()];
    self.bus = [[AJNBusAttachment alloc] initWithApplicationName:name allowRemoteMessages:YES];
    QStatus status =  [self.bus start];
    status = [self.bus connectWithArguments:@"null:"];
    if (ER_OK != status) {
        NSLog(@"Bus connect failed.");
    }
}

- (void)tearDown
{
    self.busObject = nil;
    
    if (self.shouldDeleteBusAttachment) {
        [self.bus destroy];
        self.bus = nil;
    }    
}

- (void)main
{
    [self setup];
    
    NSString *name = [NSString stringWithFormat:@"org.alljoyn.test.bastress.stressrun%d", rand()];
    QStatus status = [self.bus requestWellKnownName:name withFlags:kAJNBusNameFlagReplaceExisting | kAJNBusNameFlagDoNotQueue];
    if (ER_OK != status) {
        NSLog(@"Request for name failed (%@)", name);
    }
    
    status = [self.bus advertiseName:name withTransportMask:kAJNTransportMaskAny];
    if (ER_OK != status) {
        NSLog(@"Could not advertise (%@)", name);
    }
    
    NSString *path = @"/org/cool";
    self.busObject = [[BasicObject alloc] initWithBusAttachment:self.bus onPath:path];
    
    [self.bus registerBusObject:self.busObject];
    
    [self.bus registerBasicStringsDelegateSignalHandler:self];
    
    [self.bus unregisterSignalHandler:self];
    
    [self.bus unregisterBusObject:self.busObject];
    
    [self tearDown];
}

#pragma mark - BasicStringsDelegateSignalHandler implementation

- (void)didReceiveTestStringPropertyChangedFrom:(NSString *)oldString to:(NSString *)newString inSession:(AJNSessionId)sessionId fromSender:(NSString *)sender
{
    NSLog(@"BasicStringsDelegateSignalHandler::didReceiveTestStringPropertyChangedFrom:%@ to:%@ inSession:%u fromSender:%@", oldString, newString, sessionId, sender);
}

- (void)didReceiveTestSignalWithNoArgsInSession:(AJNSessionId)sessionId fromSender:(NSString*)sender
{
    NSLog(@"BasicStringsDelegateSignalHandler::didReceiveTestSignalWithNoArgsInSession:%u fromSender:%@", sessionId, sender);
}

@end

@implementation BusStressManager

+ (void)runStress:(NSInteger)iterations threadCount:(NSInteger)threadCount deleteBusFlag:(BOOL)shouldDeleteBusAttachment stopThreadsFlag:(BOOL)stopThreads operationMode:(BusStressManagerOperationMode)mode delegate:(id<BusStressManagerDelegate>)delegate
{
    dispatch_queue_t queue = dispatch_queue_create("bastress", NULL);
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < iterations; i++) {
            NSOperationQueue *queue = [[NSOperationQueue alloc] init];
            
            [queue setMaxConcurrentOperationCount:threadCount];
            
            for (NSInteger i = 0; i < threadCount; i++) {
                StressOperation *stressOperation;
                if (mode == kBusStressManagerOperationModeNone) {
                    stressOperation = [[StressOperation alloc] init];
                }
                else if (mode == kBusStressManagerOperationModeClient) {
                    stressOperation = [[ClientStressOperation alloc] init];
                }
                else if (mode == kBusStressManagerOperationModeService) {
                    stressOperation = [[ServiceStressOperation alloc] init];
                }
                stressOperation.shouldDeleteBusAttachment = shouldDeleteBusAttachment;
                
                [queue addOperation:stressOperation];
            }
            
            
            
            if (stopThreads) {
                sleep(rand() % 2);
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
