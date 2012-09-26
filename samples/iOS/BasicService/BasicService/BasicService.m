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

#import "BasicService.h"
#import "AJNBusAttachment.h"
#import "AJNInterfaceDescription.h"
#import "AJNSessionOptions.h"
#import "AJNVersion.h"
#import "BasicObject.h"

////////////////////////////////////////////////////////////////////////////////
//
// Constants
//

static NSString* kBasicServiceInterfaceName = @"org.alljoyn.Bus.sample";
static NSString* kBasicServiceName = @"org.alljoyn.Bus.sample";
static NSString* kBasicServicePath = @"/sample";
static const AJNSessionPort kBasicServicePort = 25;

////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Basic Service private interface
//

@interface BasicService() <AJNBusListener, AJNSessionPortListener, AJNSessionListener>

@property (nonatomic, strong) AJNBusAttachment *bus;
@property (nonatomic, strong) BasicObject *basicObject;
@property (nonatomic, strong) NSCondition *lostSessionCondition;

@end

////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Basic Service implementation
//

@implementation BasicService

@synthesize bus = _bus;
@synthesize basicObject = _basicObject;
@synthesize lostSessionCondition = _lostSessionCondition;

- (void)run
{
    
    NSLog(@"AllJoyn Library version: %@", AJNVersion.versionInformation);
    NSLog(@"AllJoyn Library build info: %@\n", AJNVersion.buildInformation);
    
    NSLog(@"+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    NSLog(@"+ Creating bus attachment                                                                 +");
    NSLog(@"+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    
    QStatus status;
    
    // create the message bus
    //
    self.bus = [[AJNBusAttachment alloc] initWithApplicationName:@"BasicService" allowRemoteMessages:YES];
    
    self.lostSessionCondition = [[NSCondition alloc] init];
    [self.lostSessionCondition lock];
    
    // register a bus listener
    //
    [self.bus registerBusListener:self];
    
    // allocate the service's bus object, which also creates and activates the service's interface
    //
    self.basicObject = [[BasicObject alloc] initWithBusAttachment:self.bus onPath:kBasicServicePath];
    
    // start the message bus
    //
    status =  [self.bus start];
    
    if (ER_OK != status) {
        NSLog(@"Bus start failed.");
    }
    
    // register the bus object
    //
    status = [self.bus registerBusObject:self.basicObject];
    if (ER_OK != status) {
        NSLog(@"ERROR: Could not register bus object");
    }
    
    // connect to the message bus
    //
    status = [self.bus connectWithArguments:@"null:"];
    
    if (ER_OK != status) {
        NSLog(@"Bus connect failed.");
    }
        
    // Advertise this service on the bus
    // There are three steps to advertising this service on the bus
    //   1) Request a well-known name that will be used by the client to discover
    //       this service
    //   2) Create a session
    //   3) Advertise the well-known name
    //

    // request the name
    //
    status = [self.bus requestWellKnownName:kBasicServiceName withFlags:kAJNBusNameFlagReplaceExisting | kAJNBusNameFlagDoNotQueue];
    if (ER_OK != status) {
        NSLog(@"ERROR: Request for name failed (%@)", kBasicServiceName);
    }
    
    
    // bind a session to a service port
    //
    AJNSessionOptions *sessionOptions = [[AJNSessionOptions alloc] initWithTrafficType:kAJNTrafficMessages supportsMultipoint:YES proximity:kAJNProximityAny transportMask:kAJNTransportMaskAny];
    
    status = [self.bus bindSessionOnPort:kBasicServicePort withOptions:sessionOptions withDelegate:self];
    if (ER_OK != status) {
        NSLog(@"ERROR: Could not bind session on port (%d)", kBasicServicePort);
    }
    
    // advertise a name
    //
    status = [self.bus advertiseName:kBasicServiceName withTransportMask:kAJNTransportMaskAny];
    if (ER_OK != status) {
        NSLog(@"Could not advertise (%@)", kBasicServiceName);
    }
    
    // wait until the client leaves before tearing down the service
    //
    [self.lostSessionCondition waitUntilDate:[NSDate dateWithTimeIntervalSinceNow:60]];
    
    // clean up
    //
    [self.bus unregisterBusObject:self.basicObject];
    
    [self.lostSessionCondition unlock];
    
    NSLog(@"+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    NSLog(@"+ Destroying bus attachment                                                               +");
    NSLog(@"+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    
    // deallocate the bus
    //
    self.bus = nil;
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
    
    [self.lostSessionCondition lock];
    [self.lostSessionCondition signal];
    [self.lostSessionCondition unlock];
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
    if (sessionPort == kBasicServicePort) {
        return YES;
    }
    return NO;
}

- (void)didJoin:(NSString*)joiner inSessionWithId:(AJNSessionId)sessionId onSessionPort:(AJNSessionPort)sessionPort
{
    NSLog(@"AJNSessionPortListener::didJoin:%@ inSessionWithId:%u onSessionPort:%u withSessionOptions:", joiner, sessionId, sessionPort);
    
}

@end
