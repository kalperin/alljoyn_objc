//
//  ViewController.h
//  BasicBusClient
//
//  Created by Guest on 10/15/12.
//  Copyright (c) 2012 Qualcomm Innovation Center, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *advertisedNameTextField;
@property (weak, nonatomic) IBOutlet UITextView *eventsTextView;

- (IBAction)didTouchStartButton:(id)sender;

@end
