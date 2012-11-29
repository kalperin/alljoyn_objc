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
#import "AJNBusAttachment.h"

@interface ViewController ()

@property (nonatomic) bool isConnectedToService;

@end

@implementation ViewController

- (AJNTransportMask)transportType
{
    AJNTransportMask transportMask;
    switch (self.transportTypeSegmentedControl.selectedSegment) {
        case 0:
            transportMask = kAJNTransportMaskAny;
            break;
            
        case 1:
            transportMask = kAJNTransportMaskICE;
            break;
            
        default:
            break;
    }
    return transportMask;
}

- (void)setIsConnectedToService:(bool)isConnectedToService
{
    NSString *title = isConnectedToService ? @"Stop" : @"Start";
    [self.startButton setTitle:title];
    _isConnectedToService = isConnectedToService;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [PingClient.sharedInstance setDelegate:self];
    }
    return self;
}

- (IBAction)didTouchStartButton:(id)sender
{
    if (!self.isConnectedToService) {
        [PingClient.sharedInstance connectToService:self.advertisedNameTextField.stringValue];
    }
    else {
        [PingClient.sharedInstance disconnect];
    }
    
    self.isConnectedToService = !self.isConnectedToService;
}

#pragma mark - PingClientDelegate implementation

- (void)didConnectWithService:(NSString *)serviceName
{
    [self receivedStatusMessage:[NSString stringWithFormat:@"Successfully connected with the service named %@", serviceName]];
    
    self.isConnectedToService = true;
}

- (void)shouldDisconnectFromService:(NSString *)serviceName
{
    [self receivedStatusMessage:[NSString stringWithFormat:@"Disconnected from the service named %@", serviceName]];
    
    if (self.isConnectedToService) {
        [PingClient.sharedInstance disconnect];
    }
    
    self.isConnectedToService = false;
}

- (void)receivedStatusMessage:(NSString *)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableString *string = self.eventsTextView.string.length ? [self.eventsTextView.string mutableCopy] : [[NSMutableString alloc] init];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeStyle:NSDateFormatterMediumStyle];
        [formatter setDateStyle:NSDateFormatterShortStyle];
        [string appendFormat:@"[%@] ",[formatter stringFromDate:[NSDate date]]];
        [string appendString:message];
        [self.eventsTextView setString:string];
        NSLog(@"%@",string);
    });
}


@end
