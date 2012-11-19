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
#import "PingService.h"

@interface ViewController () <PingServiceDelegate>

@property (nonatomic) BOOL isStarted;

@end

@implementation ViewController

@synthesize advertisedNameTextField = _advertisedNameTextField;
@synthesize eventsTextView = _eventsTextView;
@synthesize startButton = _startButton;
@synthesize isStarted = _isStarted;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [PingService.sharedInstance setDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTouchStartButton:(id)sender
{
    if (self.isStarted) {
        [PingService.sharedInstance stop];
        [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
    }
    else {
        [PingService.sharedInstance start:self.advertisedNameTextField.text];
        [self.startButton setTitle:@"Stop" forState:UIControlStateNormal];
    }
    self.isStarted = !self.isStarted;
}

#pragma mark - PingServiceDelegate implementation

- (AJNTransportMask)transportType
{
    AJNTransportMask transportMask;
    switch (self.transportTypeSegmentedControl.selectedSegmentIndex) {
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

// The delegate is called once a client joins a session with the service
//
- (void)client:(NSString *)clientName didJoinSession:(AJNSessionId)sessionId
{
    [self receivedStatusMessage:[NSString stringWithFormat:@"Client %@ joined session %d", clientName, sessionId]];
}

// The delegate is called when a client leaves a session
//
- (void)client:(NSString *)clientName didLeaveSession:(AJNSessionId)sessionId
{
    [self receivedStatusMessage:[NSString stringWithFormat:@"Client %@ left session %d", clientName, sessionId]];    
}

// Send updates on internal state of Ping Service
//
- (void)receivedStatusMessage:(NSString*)message
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
