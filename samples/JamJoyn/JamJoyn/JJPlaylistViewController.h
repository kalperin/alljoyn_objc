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

@interface JJPlaylistViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *songLabel;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;
@property (weak, nonatomic) IBOutlet UILabel *currentPlaybackPositionLabel;
@property (weak, nonatomic) IBOutlet UILabel *playbackTimeRemainingLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (weak, nonatomic) IBOutlet UISlider *playbackProgressSlider;

- (IBAction)didTouchPlayButton:(id)sender;
- (IBAction)didTouchPauseButton:(id)sender;
- (IBAction)didTouchStopButton:(id)sender;
- (IBAction)didTouchAddSongButton:(id)sender;
- (IBAction)didTouchVolumeUpButton:(id)sender;
- (IBAction)didTouchVolumeDownButton:(id)sender;
- (IBAction)didTouchEditButton:(id)sender;
- (IBAction)playbackSliderPositionDidChange:(id)sender;

@end
