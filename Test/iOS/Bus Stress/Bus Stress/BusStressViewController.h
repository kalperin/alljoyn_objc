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

#import <UIKit/UIKit.h>

@interface BusStressViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UILabel *numberOfThreadsLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfIterationsLabel;
@property (weak, nonatomic) IBOutlet UISwitch *stopThreadsBeforeJoinSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *deleteBusAttachmentsSwitch;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UILabel *iterationsCompletedLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *iterationsCompletedProgressView;
@property (weak, nonatomic) IBOutlet UISlider *numberOfIterationsSlider;
@property (weak, nonatomic) IBOutlet UISlider *numberOfThreadsSlider;
@property (weak, nonatomic) IBOutlet UISegmentedControl *operationModeSegmentedControl;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *stressTestActivityIndicatorView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *transportTypeSegmentedControl;

- (IBAction)didTouchStartButton:(id)sender;
- (IBAction)didTouchStopButton:(id)sender;
- (IBAction)numberOfIterationsValueChanged:(id)sender;
- (IBAction)numberOfThreadsValueChanged:(id)sender;

@end
