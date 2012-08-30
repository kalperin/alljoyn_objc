//
//  BusStressViewController.h
//  Bus Stress
//
//  Created by Guest on 8/27/12.
//  Copyright (c) 2012 Qualcomm Innovation Center, Inc. All rights reserved.
//

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

- (IBAction)didTouchStartButton:(id)sender;
- (IBAction)numberOfIterationsValueChanged:(id)sender;
- (IBAction)numberOfThreadsValueChanged:(id)sender;

@end
