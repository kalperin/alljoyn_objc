//
//  AuthenticationTests.m
//  AllJoynFramework
//
//  Created by  on 7/3/12.
//  Copyright (c) 2012 2012 Qualcomm Innovation Center, Inc. All rights reserved.
//

#import "AuthenticationTests.h"

#import "AJNBusAttachment.h"
#import "AJNInterfaceDescription.h"
#import "AJNBasicObject.h"
#import "BasicObject.h"

static NSString * const kAuthenticationTestsAdvertisedName = @"org.alljoyn.bus.sample.strings";
static NSString * const kAuthenticationTestsInterfaceName = @"org.alljoyn.bus.sample.strings";
static NSString * const kAuthenticationTestsObjectPath = @"/basic_object";
const NSTimeInterval kAuthenticationTestsWaitTimeBeforeFailure = 5.0;
const NSInteger kAuthenticationTestsServicePort = 999;

@interface AuthenticationTests()<AJNBusListener, AJNSessionListener, AJNSessionPortListener, BasicStringsDelegateSignalHandler>

@property (nonatomic, strong) AJNBusAttachment *bus;
@property (nonatomic) BOOL listenerDidRegisterWithBusCompleted;
@property (nonatomic) BOOL listenerDidUnregisterWithBusCompleted;
@property (nonatomic) BOOL didFindAdvertisedNameCompleted;
@property (nonatomic) BOOL didLoseAdvertisedNameCompleted;
@property (nonatomic) BOOL nameOwnerChangedCompleted;
@property (nonatomic) BOOL busWillStopCompleted;
@property (nonatomic) BOOL busDidDisconnectCompleted;
@property (nonatomic) BOOL sessionWasLost;
@property (nonatomic) BOOL didAddMemberNamed;
@property (nonatomic) BOOL didRemoveMemberNamed;
@property (nonatomic) BOOL shouldAcceptSessionJoinerNamed;
@property (nonatomic) BOOL didJoinInSession;
@property (nonatomic) AJNSessionId testSessionId;
@property (nonatomic, strong) NSString *testSessionJoiner;
@property (nonatomic) BOOL isTestClient;
@property (nonatomic) BOOL clientConnectionCompleted;
@property (nonatomic) BOOL didReceiveSignal;

@end

@implementation AuthenticationTests

@synthesize bus = _bus;
@synthesize listenerDidRegisterWithBusCompleted = _listenerDidRegisterWithBusCompleted;
@synthesize listenerDidUnregisterWithBusCompleted = _listenerDidUnregisterWithBusCompleted;
@synthesize didFindAdvertisedNameCompleted = _didFindAdvertisedNameCompleted;
@synthesize didLoseAdvertisedNameCompleted = _didLoseAdvertisedNameCompleted;
@synthesize nameOwnerChangedCompleted = _nameOwnerChangedCompleted;
@synthesize busWillStopCompleted = _busWillStopCompleted;
@synthesize busDidDisconnectCompleted = _busDidDisconnectCompleted;
@synthesize sessionWasLost = _sessionWasLost;
@synthesize didAddMemberNamed = _didAddMemberNamed;
@synthesize didRemoveMemberNamed = _didRemoveMemberNamed;
@synthesize shouldAcceptSessionJoinerNamed = _shouldAcceptSessionJoinerNamed;
@synthesize didJoinInSession = _didJoinInSession;
@synthesize testSessionId = _testSessionId;
@synthesize testSessionJoiner = _testSessionJoiner;
@synthesize isTestClient = _isTestClient;
@synthesize clientConnectionCompleted = _clientConnectionCompleted;
@synthesize didReceiveSignal = _didReceiveSignal;
@synthesize handle = _handle;

- (void)setUp
{
    [super setUp];
    
    // Set-up code here. Executed before each test case is run.
    //
    self.bus = [[AJNBusAttachment alloc] initWithApplicationName:@"testApp" allowingRemoteMessages:YES];
    self.listenerDidRegisterWithBusCompleted = NO;
    self.listenerDidUnregisterWithBusCompleted = NO;
    self.didFindAdvertisedNameCompleted = NO;
    self.didLoseAdvertisedNameCompleted = NO;
    self.nameOwnerChangedCompleted = NO;
    self.busWillStopCompleted = NO;
    self.busDidDisconnectCompleted = NO;
    
    self.sessionWasLost = NO;
    self.didAddMemberNamed = NO;
    self.didRemoveMemberNamed = NO;
    self.shouldAcceptSessionJoinerNamed = NO;
    self.didJoinInSession = NO;
    self.isTestClient = NO;
    self.clientConnectionCompleted = NO;
    self.didReceiveSignal = NO;
    self.testSessionId = -1;
    self.testSessionJoiner = nil;
}

- (void)tearDown
{
    // Tear-down code here. Executed after each test case is run.
    //
    [self.bus destroy];
    [self.bus destroyBusListener:self];
    self.bus = nil;    
    self.listenerDidRegisterWithBusCompleted = NO;
    self.listenerDidUnregisterWithBusCompleted = NO;
    self.didFindAdvertisedNameCompleted = NO;
    self.didLoseAdvertisedNameCompleted = NO;
    self.nameOwnerChangedCompleted = NO;
    self.busWillStopCompleted = NO;
    self.busDidDisconnectCompleted = NO;
    
    self.sessionWasLost = NO;
    self.didAddMemberNamed = NO;
    self.didRemoveMemberNamed = NO;
    self.shouldAcceptSessionJoinerNamed = NO;
    self.didJoinInSession = NO;
    self.isTestClient = NO;
    self.clientConnectionCompleted = NO;
    self.didReceiveSignal = NO;
    self.testSessionId = -1;
    self.testSessionJoiner = nil;
    
    [super tearDown];
}

#pragma mark - Asynchronous test case support

- (BOOL)waitForBusToStop:(NSTimeInterval)timeoutSeconds
{
    return [self waitForCompletion:timeoutSeconds onFlag:&_busWillStopCompleted];
}

- (BOOL)waitForCompletion:(NSTimeInterval)timeoutSeconds onFlag:(BOOL*)flag
{
    NSDate *timeoutDate = [NSDate dateWithTimeIntervalSinceNow:timeoutSeconds];
    
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:timeoutDate];
        if ([timeoutDate timeIntervalSinceNow] < 0.0) {
            break;
        }
    } while (!*flag);
    
    return *flag;
}

#pragma mark - AJNBusListener delegate methods

- (void)listenerDidRegisterWithBus:(AJNBusAttachment*)busAttachment
{
    NSLog(@"AJNBusListener::listenerDidRegisterWithBus:%@",busAttachment);
    self.listenerDidRegisterWithBusCompleted = YES;
}

- (void)listenerDidUnregisterWithBus:(AJNBusAttachment*)busAttachment
{
    NSLog(@"AJNBusListener::listenerDidUnregisterWithBus:%@",busAttachment);
    self.listenerDidUnregisterWithBusCompleted = YES;    
}

- (void)didFindAdvertisedName:(NSString*)name withTransportMask:(AJNTransportMask)transport namePrefix:(NSString*)namePrefix
{
    NSLog(@"AJNBusListener::didFindAdvertisedName:%@ withTransportMask:%u namePrefix:%@", name, transport, namePrefix);
    if ([name compare:kAuthenticationTestsAdvertisedName] == NSOrderedSame) {
        self.didFindAdvertisedNameCompleted = YES;
        if (self.isTestClient) {
            
            AJNSessionOptions *sessionOptions = [[AJNSessionOptions alloc] initWithTrafficType:kAJNTrafficMessages supportsMultipoint:NO proximity:kAJNProximityAny transportMask:kAJNTransportMaskAny];
            
            self.testSessionId = [self.bus joinSessionWithName:name onPort:kAuthenticationTestsServicePort withDelegate:self options:sessionOptions];
            STAssertTrue(self.testSessionId != -1, @"Test client failed to connect to the service %@ on port %u", name, kAuthenticationTestsServicePort);
            
            self.clientConnectionCompleted = YES;
        }
    }
}

- (void)didLoseAdvertisedName:(NSString*)name withTransportMask:(AJNTransportMask)transport namePrefix:(NSString*)namePrefix
{
    NSLog(@"AJNBusListener::listenerDidUnregisterWithBus:%@ withTransportMask:%u namePrefix:%@",name,transport,namePrefix);    
    self.didLoseAdvertisedNameCompleted = YES;    
}

- (void)nameOwnerChanged:(NSString*)name to:(NSString*)newOwner from:(NSString*)previousOwner
{
    NSLog(@"AJNBusListener::nameOwnerChanged:%@ to:%@ from:%@", name, newOwner, previousOwner);    
    if ([name compare:kAuthenticationTestsAdvertisedName] == NSOrderedSame) {
        self.nameOwnerChangedCompleted = YES;
    }
}

- (void)busWillStop
{
    NSLog(@"AJNBusListener::busWillStop");
    self.busWillStopCompleted = YES;    
}

- (void)busDidDisconnect
{
    NSLog(@"AJNBusListener::busDidDisconnect");    
    self.busDidDisconnectCompleted = YES;    
}

#pragma mark - AJNSessionListener methods

- (void)sessionWasLost:(AJNSessionId)sessionId
{
    NSLog(@"AJNBusListener::sessionWasLost %u", sessionId);
    if (self.testSessionId == sessionId) {
        self.sessionWasLost = YES;
    }
    
}

- (void)didAddMemberNamed:(NSString*)memberName toSession:(AJNSessionId)sessionId
{
    NSLog(@"AJNBusListener::didAddMemberNamed:%@ toSession:%u", memberName, sessionId);    
    if (self.testSessionId == sessionId) {
        self.didAddMemberNamed = YES;        
    }
}

- (void)didRemoveMemberNamed:(NSString*)memberName fromSession:(AJNSessionId)sessionId
{
    NSLog(@"AJNBusListener::didRemoveMemberNamed:%@ fromSession:%u", memberName, sessionId);    
    if (self.testSessionId == sessionId) {    
        self.didRemoveMemberNamed = YES;
    }
}

#pragma mark - AJNSessionPortListener implementation

- (BOOL)shouldAcceptSessionJoinerNamed:(NSString*)joiner onSessionPort:(AJNSessionPort)sessionPort withSessionOptions:(AJNSessionOptions*)options
{
    NSLog(@"AJNSessionPortListener::shouldAcceptSessionJoinerNamed:%@ onSessionPort:%u withSessionOptions:", joiner, sessionPort);    
    if (sessionPort == kAuthenticationTestsServicePort) {
        self.shouldAcceptSessionJoinerNamed = YES;
        return YES;
    }
    return NO;
}

- (void)didJoin:(NSString*)joiner inSessionWithId:(AJNSessionId)sessionId onSessionPort:(AJNSessionPort)sessionPort
{
    NSLog(@"AJNSessionPortListener::didJoin:%@ inSessionWithId:%u onSessionPort:%u withSessionOptions:", joiner, sessionId, sessionPort);    
    if (sessionPort == kAuthenticationTestsServicePort) {
        self.testSessionId = sessionId;
        self.didJoinInSession = YES;
    }
}

#pragma mark - AJNSessionDelegate implementation

- (void)didJoinSession:(AJNSessionId)sessionId status:(QStatus)status sessionOptions:(AJNSessionOptions *)sessionOptions context:(AJNHandle)context
{
    self.testSessionId = sessionId;
    STAssertTrue(self.testSessionId != -1, @"Test client failed to connect asynchronously using delegate to the service on port %u", kAuthenticationTestsServicePort);
    
    self.clientConnectionCompleted = YES;            
    
}

#pragma mark - BasicStringsDelegateSignalHandler implementation

- (void)didReceiveTestStringPropertyChangedFrom:(NSString *)oldString to:(NSString *)newString inSession:(AJNSessionId)sessionId fromSender:(NSString *)sender
{
    NSLog(@"BasicStringsDelegateSignalHandler::didReceiveTestStringPropertyChangedFrom:%@ to:%@ inSession:%u fromSender:%@", oldString, newString, sessionId, sender);
    self.didReceiveSignal = YES;
}

- (void)didReceiveTestSignalWithNoArgsInSession:(AJNSessionId)sessionId fromSender:(NSString*)sender
{
    
}


@end
