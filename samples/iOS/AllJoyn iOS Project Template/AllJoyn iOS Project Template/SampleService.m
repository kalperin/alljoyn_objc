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

#import "Constants.h"
#import "SampleService.h"
#import "AJNBusAttachment.h"
#import "SampleObject.h"
#import "AJNSessionOptions.h"

static SampleService *s_sharedInstance;

@interface SampleService() <AJNBusListener, AJNSessionListener, AJNSessionPortListener>

@property (nonatomic, strong) AJNBusAttachment *bus;
@property (nonatomic, strong) SampleObject *sampleObject;

@end

@implementation SampleService

@synthesize bus = _bus;
@synthesize sampleObject = _sampleObject;

- (void)start
{
    // NOTE: no error handling is in place here to keep the code easy to read.
    // you should add error checking for each of these calls
    //

    // create the session options for this service's connections with its clients
    //
    AJNSessionOptions *sessionOptions = [[AJNSessionOptions alloc] initWithTrafficType:kAJNTrafficMessages supportsMultipoint:NO proximity:kAJNProximityAny transportMask:kAJNTransportMaskAny];
    
    
    // allocate and initalize the bus
    //
    self.bus = [[AJNBusAttachment alloc] initWithApplicationName:kAppName allowRemoteMessages:YES];
    
    // start the bus
    //
    [self.bus start];
    
    // create our custom sample bus object that will concatenate two strings
    // and return the result of the concatenation
    //
    self.sampleObject = [[SampleObject alloc] initWithBusAttachment:self.bus onPath:kServicePath];
    
    // register the sample object with the bus
    //
    [self.bus registerBusObject:self.sampleObject];
    
    // connect the bus using the null transport, which communicates to the bundled
    // daemon directly
    //
    [self.bus connectWithArguments:@"null:"];
    
    // register the SampleService object as a bus listener, which allows us to find
    // well known names that are advertised on the bus.
    //
    [self.bus registerBusListener:self];
    
    // request to become the owner of the service name for the sample object
    //
    [self.bus requestWellKnownName:kServiceName withFlags:kAJNBusNameFlagReplaceExisting|kAJNBusNameFlagDoNotQueue];
        
    // bind the session to a specific service port
    //
    [self.bus bindSessionOnPort:kServicePort withOptions:sessionOptions withDelegate:self];
    
    // let others on the bus know that this service exists
    //
    [self.bus advertiseName:kServiceName withTransportMask:sessionOptions.transports];
}

- (void)stop
{
    // unregister as a listener
    //
    [self.bus unregisterBusListener:self];
    
    // disconnect the bus
    //
    [self.bus disconnectWithArguments:@"null:"];
    
    // stop the bus
    //
    [self.bus stop];
    
    // let our object deallocate
    //
    self.sampleObject = nil;
    
    // destroy the bus
    //
    [self.bus destroy];
    
    // destroy the listener
    //
    [self.bus destroyBusListener:self];
    
    // deallocate the bus
    //
    self.bus = nil;    
}

#pragma mark - AJNBusListener delegate methods

- (void)didFindAdvertisedName:(NSString *)name withTransportMask:(AJNTransportMask)transport namePrefix:(NSString *)namePrefix
{
    NSLog(@"SampleService::didFindAdvertisedName:%@ withTransportMask:%i namePrefix:%@", name, transport, namePrefix);
    
}

- (void)didLoseAdvertisedName:(NSString*)name withTransportMask:(AJNTransportMask)transport namePrefix:(NSString*)namePrefix
{
    NSLog(@"SampleService::didLoseAdvertisedName:%@ withTransportMask:%i namePrefix:%@", name, transport, namePrefix);
    
}

- (void)nameOwnerChanged:(NSString *)name to:(NSString *)newOwner from:(NSString *)previousOwner
{
    NSLog(@"SampleService::nameOwnerChanged:%@ to:%@ namePrefix:%@", name, newOwner, previousOwner);    
}

#pragma mark - AJNSessionPortListener delegate methods

- (void)didJoin:(NSString *)joiner inSessionWithId:(AJNSessionId)sessionId onSessionPort:(AJNSessionPort)sessionPort
{
    NSLog(@"SampleService::didJoin:%@ inSessionWithId:%u onSessionPort:%u", joiner, sessionId, sessionPort);    
    
}

- (BOOL)shouldAcceptSessionJoinerNamed:(NSString *)joiner onSessionPort:(AJNSessionPort)sessionPort withSessionOptions:(AJNSessionOptions *)options
{
    NSLog(@"SampleService::shouldAcceptSessionJoinerNamed:%@ onSessionPort:%u", joiner, sessionPort);
    
    // only allow session joiners who use our designated port number
    //
    return sessionPort == kServicePort;
}

#pragma mark - AJNSessionListener delegate methods

- (void)sessionWasLost:(AJNSessionId)sessionId
{
    NSLog(@"SampleService::sessionWasLost:%u", sessionId);            
}

- (void)didAddMemberNamed:(NSString*)memberName toSession:(AJNSessionId)sessionId
{
    NSLog(@"SampleService::didAddMemberNamed:%@ toSession:%u", memberName, sessionId);  
}

- (void)didRemoveMemberNamed:(NSString*)memberName fromSession:(AJNSessionId)sessionId
{
    NSLog(@"SampleService::didRemoveMemberNamed:%@ fromSession:%u", memberName, sessionId);                    
}

#pragma mark - Class methods

+ (void)initialize
{
    @synchronized(self) {
        if (s_sharedInstance == nil) {
            s_sharedInstance = [[SampleService alloc] init];
        }
    }
}

+ (SampleService*)sharedInstance
{
    @synchronized(self) {
        return s_sharedInstance;
    }
}

@end
