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
#import "Constants.h"
#import "AJNServiceController.h"
#import "FileTransferObject.h"

@interface ViewController () <AJNServiceDelegate>

@property (nonatomic, strong) AJNServiceController *serviceController;
@property (nonatomic, strong) FileTransferObject *fileTransferObject;

- (AJNBusObject *)objectOnBus:(AJNBusAttachment *)bus;
- (void)shouldUnloadObjectOnBus:(AJNBusAttachment *)bus;

@end

@implementation ViewController

@synthesize serviceController = _serviceController;
@synthesize fileTransferObject = _fileTransferObject;

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
    return self.fileTransferObject;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    // allocate the service bus controller and set bus properties
    //
    self.serviceController = [[AJNServiceController alloc] init];
    self.serviceController.trafficType = kAJNTrafficMessages;
    self.serviceController.proximityOptions = kAJNProximityAny;
    self.serviceController.transportMask = kAJNTransportMaskAny;
    self.serviceController.allowRemoteMessages = YES;
    self.serviceController.multiPointSessionsEnabled = NO;
    self.serviceController.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


- (void)shouldUnloadObjectOnBus:(AJNBusAttachment *)bus
{
    self.fileTransferObject = nil;
    [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
}

- (AJNBusObject *)objectOnBus:(AJNBusAttachment *)bus
{
    self.fileTransferObject = [[FileTransferObject alloc] initWithBusAttachment:self.serviceController.bus onPath:kServicePath];
    
    return self.fileTransferObject;
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
