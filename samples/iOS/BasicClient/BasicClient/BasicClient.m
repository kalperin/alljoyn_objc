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

#import "BasicClient.h"
#import "AJNBusAttachment.h"
#import "AJNInterfaceDescription.h"
#import "AJNSessionOptions.h"
#import "AJNVersion.h"
#import "BasicObject.h"

////////////////////////////////////////////////////////////////////////////////
//
// Constants
//

static NSString* kBasicClientInterfaceName = @"org.alljoyn.Bus.sample";
static NSString* kBasicClientServiceName = @"org.alljoyn.Bus.sample";
static NSString* kBasicClientServicePath = @"/sample";
static const AJNSessionPort kBasicClientServicePort = 25;

////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Basic Client private interface
//

@interface BasicClient() <AJNBusListener, AJNSessionListener>

@property (nonatomic, strong) AJNBusAttachment *bus;
@property (nonatomic, strong) NSCondition *joinedSessionCondition;
@property (nonatomic) AJNSessionId sessionId;
@property (nonatomic, strong) NSString *foundServiceName;
@property (nonatomic, strong) BasicObjectProxy *basicObjectProxy;
@property BOOL wasNameAlreadyFound;

@end

////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Basic Client implementation
//

@implementation BasicClient

@synthesize bus = _bus;
@synthesize joinedSessionCondition = _joinedSessionCondition;
@synthesize sessionId = _sessionId;
@synthesize foundServiceName = _foundServiceName;
@synthesize basicObjectProxy = _basicObjectProxy;
@synthesize wasNameAlreadyFound = _wasNameAlreadyFound;

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
    self.bus = [[AJNBusAttachment alloc] initWithApplicationName:@"BasicClient" allowRemoteMessages:YES];
    
    // create an interface description
    //
    AJNInterfaceDescription *interfaceDescription = [self.bus createInterfaceWithName:@"org.alljoyn.bus.sample" enableSecurity:NO];
    
    // add the methods to the interface description
    //
    status = [interfaceDescription addMethodWithName:@"cat" inputSignature:@"ss" outputSignature:@"s" argumentNames:[NSArray arrayWithObjects:@"str1",@"str2",@"outStr", nil]];
    
    if (status != ER_OK && status != ER_BUS_MEMBER_ALREADY_EXISTS) {
        @throw [NSException exceptionWithName:@"BusObjectInitFailed" reason:@"Unable to add method to interface: cat" userInfo:nil];
    }
    
    [interfaceDescription activate];
    
    // start the message bus
    //
    status =  [self.bus start];

    if (ER_OK != status) {
        NSLog(@"Bus start failed.");
    }
    
    // connect to the message bus
    //
    status = [self.bus connectWithArguments:@"null:"];
    
    if (ER_OK != status) {
        NSLog(@"Bus connect failed.");
    }
    
    self.joinedSessionCondition = [[NSCondition alloc] init];
    [self.joinedSessionCondition lock];
    
    // register a bus listener in order to receive discovery notifications
    //
    [self.bus registerBusListener:self];
    
    // begin discovery of the well known name of the service to be called
    //
    [self.bus findAdvertisedName:kBasicClientServiceName];
    
    // wait for the join session to complete
    //
    if ([self.joinedSessionCondition waitUntilDate:[NSDate dateWithTimeIntervalSinceNow:60]]) {
        
        // once joined to a session, use a proxy object to make the function call
        //
        self.basicObjectProxy = [[BasicObjectProxy alloc] initWithBusAttachment:self.bus serviceName:self.foundServiceName objectPath:kBasicClientServicePath sessionId:self.sessionId];
        
        // get a description of the interfaces implemented by the remote object before making the call
        //
        [self.basicObjectProxy introspectRemoteObject];
        
        // now make the function call
        //
        NSString *result = [self.basicObjectProxy concatenateString:@"Code " withString:@"Monkies!!!!!!!"];
        
        if (result) {
            NSLog(@"[%@] %@ concatenated string.", result, [result compare:@"Code Monkies!!!!!!!"] == NSOrderedSame ? @"Successfully":@"Unsuccessfully");
        }
        
        self.basicObjectProxy = nil;
        
    }
    else {
        NSLog(@"Timed out while attempting to join a session with BasicService...");
    }
    
    [self.joinedSessionCondition unlock];
    
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
    
    if ([namePrefix compare:kBasicClientServiceName] == NSOrderedSame) {
        
        BOOL shouldReturn;
        @synchronized(self) {
            shouldReturn = self.wasNameAlreadyFound;
            self.wasNameAlreadyFound = true;
        }
        
        if (shouldReturn) {
            NSLog(@"Already found an advertised name, ignoring this name %@...", name);
            return;
        }
        
        // Since we are in a callback we must enable concurrent callbacks before calling a synchronous method.
        //
        [self.bus enableConcurrentCallbacks];
        
        self.sessionId = [self.bus joinSessionWithName:name onPort:kBasicClientServicePort withDelegate:self options:[[AJNSessionOptions alloc] initWithTrafficType:kAJNTrafficMessages supportsMultipoint:YES proximity:kAJNProximityAny transportMask:kAJNTransportMaskAny]];
        
        if (self.sessionId) {
            self.foundServiceName = name;
            
            NSLog(@"Client joined session %d", self.sessionId);
        }
        
        [self.joinedSessionCondition signal];
    }
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


@end
