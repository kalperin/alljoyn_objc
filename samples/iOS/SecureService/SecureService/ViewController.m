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

#import "ViewController.h"
#import "AJNServiceController.h"
#import "SecureObject.h"
#import "Constants.h"

@interface ViewController () <AJNServiceDelegate, AJNAuthenticationListener>

@property (nonatomic, strong) SecureObject *secureObject;
@property (nonatomic, strong) AJNServiceController *serviceController;

- (AJNBusObject *)objectOnBus:(AJNBusAttachment *)bus;
- (void)shouldUnloadObjectOnBus:(AJNBusAttachment *)bus;

- (void)didStartBus:(AJNBusAttachment *)bus;

@end

@implementation ViewController

@synthesize secureObject = _secureObject;
@synthesize startButton = _startButton;
@synthesize serviceController = _serviceController;
@synthesize password = _password;

- (NSString *)applicationName
{
    return kAppName;
}

- (NSString *)serviceName
{
    return kServiceName;
}

- (AJNBusNameFlag)serviceNameFlags
{
    return kAJNBusNameFlagDoNotQueue | kAJNBusNameFlagReplaceExisting;
}

- (AJNSessionPort)sessionPort
{
    return kServicePort;
}

- (AJNBusObject *)object
{
    return self.secureObject;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // allocate the client bus controller and set bus properties
    //
    self.serviceController = [[AJNServiceController alloc] init];
    self.serviceController.trafficType = kAJNTrafficMessages;
    self.serviceController.proximityOptions = kAJNProximityAny;
    self.serviceController.transportMask = kAJNTransportMaskAny;
    self.serviceController.allowRemoteMessages = YES;
    self.serviceController.multiPointSessionsEnabled = YES;
    self.serviceController.delegate = self;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.passwordLabel.text = self.password;
}

- (IBAction)didTouchStartButton:(id)sender
{
    if (self.serviceController.bus.isStarted) {
        [self.serviceController stop];
        [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
    }
    else {
        [self.serviceController start];
        [self.startButton setTitle:@"Stop" forState:UIControlStateNormal];        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)shouldUnloadObjectOnBus:(AJNBusAttachment *)bus
{
    self.secureObject = nil;
    [self.startButton setTitle:@"Start" forState:UIControlStateNormal];        
}

- (AJNBusObject *)objectOnBus:(AJNBusAttachment *)bus
{
    self.secureObject = [[SecureObject alloc] initWithBusAttachment:self.serviceController.bus onPath:kServicePath];
    
    return self.secureObject;
}

- (void)didStartBus:(AJNBusAttachment *)bus
{
    // enable security for the bus
    //
    QStatus status = [bus enablePeerSecurity:@"ALLJOYN_SRP_KEYX" authenticationListener:self keystoreFileName:@"Documents/alljoyn_keystore/s_central.ks" sharing:YES];
    NSString *message;
    if (status != ER_OK) {
        message = [NSString stringWithFormat:@"ERROR: Failed to enable security on the bus. %@", [AJNStatus descriptionForStatusCode:status]];
    }
    else {
        message = @"Successfully enabled security for the bus";
    }
    NSLog(@"%@",message);
    [self didReceiveStatusMessage:message];
}

- (void)authenticationUsing:(NSString *)authenticationMechanism forRemotePeer:(NSString *)peerName didCompleteWithStatus:(BOOL)success
{
    NSString *message = [NSString stringWithFormat:@"Authentication %@ %@.", authenticationMechanism, success ? @"successful" : @"failed"];
    NSLog(@"%@", message);
    [self didReceiveStatusMessage:message];
}

- (AJNSecurityCredentials *)requestSecurityCredentialsWithAuthenticationMechanism:(NSString *)authenticationMechanism peerName:(NSString *)peerName authenticationCount:(uint16_t)authenticationCount userName:(NSString *)userName credentialTypeMask:(AJNSecurityCredentialType)mask
{
    NSLog(@"RequestCredentials for authenticating %@ using mechanism %@", peerName, authenticationMechanism);
    AJNSecurityCredentials *credentials = nil;
    if ([authenticationMechanism compare:@"ALLJOYN_SRP_KEYX"] == NSOrderedSame) {
        if (mask & kAJNSecurityCredentialTypePassword) {
            if (authenticationCount <= 3) {
                credentials = [[AJNSecurityCredentials alloc] init];
                credentials.password = self.password;
            }
        }
    }
    return credentials;
}

- (void)didReceiveStatusMessage:(NSString*)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableString *string = self.eventsTextView.text.length ? [self.eventsTextView.text mutableCopy] : [[NSMutableString alloc] init];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeStyle:NSDateFormatterMediumStyle];
        [formatter setDateStyle:NSDateFormatterShortStyle];
        [string appendFormat:@"[%@]\n",[formatter stringFromDate:[NSDate date]]];
        [string appendString:message];
        [string appendString:@"\n\n"];
        [self.eventsTextView setText:string];
        NSLog(@"%@",string);
        [self.eventsTextView scrollRangeToVisible:NSMakeRange([self.eventsTextView.text length], 0)];
    });
}


@end
