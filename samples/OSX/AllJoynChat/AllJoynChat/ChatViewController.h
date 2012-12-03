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

#import <Cocoa/Cocoa.h>

@interface ChatViewController : NSViewController<NSWindowDelegate>

@property (weak) IBOutlet NSTextField *advertisedNameTextField;
@property (weak) IBOutlet NSSegmentedControl *sessionTypeSegmentedControl;
@property (weak) IBOutlet NSSegmentedControl *transportTypeSegmentedControl;
@property (weak) IBOutlet NSButton *startButton;
@property (unsafe_unretained) IBOutlet NSTextView *conversationTextView;
@property (weak) IBOutlet NSTextField *messageTextField;
@property (weak) IBOutlet NSButton *stopButton;

- (IBAction)didTouchStartButton:(id)sender;
- (IBAction)didTouchStopButton:(id)sender;
- (IBAction)didTouchSendButton:(id)sender;

- (void)windowWillClose:(NSNotification *)notification;

@end
