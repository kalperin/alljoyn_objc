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

#import <MediaPlayer/MPVolumeView.h>
#import <alljoyn/BusAttachment.h>
#import "JJPlaylistViewController.h"
#import "JJManager.h"

struct JJSong
{
    int32_t songId;
    qcc::String songPath;
    qcc::String songName;
    qcc::String artist;
    qcc::String album;
    int32_t albumId;
    qcc::String artPath;
    qcc::String fileName;
    qcc::String busId;   
};

@interface JJPlaylistViewController () <JJManagerDelegate>

@property (nonatomic) BOOL willShowSongDetails;
@property (nonatomic) int position;
@property (nonatomic) int duration;
@property (nonatomic) NSInteger nowPlayingSongIndex;
@property (nonatomic, strong) MPVolumeView *volumeControl;
@property (nonatomic, weak) UIProgressView *playbackProgressView;
@property (nonatomic, weak) UIActivityIndicatorView *playbackActivityIndicatorView;

@end

@implementation JJPlaylistViewController
@synthesize songLabel = _songLabel;
@synthesize stopButton = _stopButton;
@synthesize playButton = _playButton;
@synthesize pauseButton = _pauseButton;
@synthesize currentPlaybackPositionLabel = _currentPlaybackPositionLabel;
@synthesize playbackTimeRemainingLabel = _playbackTimeRemainingLabel;
@synthesize editButton = _editButton;
@synthesize playbackProgressSlider = _playbackProgressSlider;
@synthesize volumeControl = _volumeControl;
@synthesize tableView = _tableView;
@synthesize playbackProgressView = _playbackProgressView;
@synthesize playbackActivityIndicatorView = _playbackActivityIndicatorView;

@synthesize willShowSongDetails = _willShowSongDetails;
@synthesize position = _position;
@synthesize duration = _duration;
@synthesize nowPlayingSongIndex = _nowPlayingSongIndex;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.volumeControl = [[MPVolumeView alloc] initWithFrame:CGRectMake(320, 378, 270, 30)];
    [self.view addSubview:self.volumeControl];
    [self.volumeControl setHidden:YES];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.willShowSongDetails = NO;
    
    JJManager.sharedInstance.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    if (!self.willShowSongDetails) {
        [JJManager.sharedInstance leaveRoom];    
    }
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setSongLabel:nil];
    [self setStopButton:nil];
    [self setPlayButton:nil];
    [self setPauseButton:nil];
    [self setCurrentPlaybackPositionLabel:nil];
    [self setPlaybackTimeRemainingLabel:nil];
    [self setEditButton:nil];
    [self setPlaybackProgressSlider:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return JJManager.sharedInstance.playlistSongCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"songCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UIImageView *albumImageView = (UIImageView*)[cell viewWithTag:1];
    UILabel *artistNameLabel = (UILabel*)[cell viewWithTag:3];
    UILabel *songNameLabel = (UILabel*)[cell viewWithTag:2];
    UIActivityIndicatorView *playMarker = (UIActivityIndicatorView*)[cell viewWithTag:10];
    
    // Configure the cell...
    JJSong *song = (JJManager.sharedInstance.playlist + indexPath.row);
    songNameLabel.text = [NSString stringWithCString:song->songName.c_str() encoding:NSUTF8StringEncoding];
    artistNameLabel.text = [NSString stringWithCString:song->artist.c_str() encoding:NSUTF8StringEncoding];

    NSString *albumPrefix = [[[[NSString stringWithCString:song->songPath.c_str() encoding:NSUTF8StringEncoding] lastPathComponent] componentsSeparatedByString:@"\\"] objectAtIndex:0];
    albumPrefix = [albumPrefix stringByAppendingString:@".jpg"];
    UIImage *image = [UIImage imageNamed:albumPrefix];
    if (!image) {
        image = [UIImage imageNamed:@"Alljoyn-Icon"];
    }
    albumImageView.image = image;
    
    NSLog(@"Row=%i Now Playing=%i", indexPath.row, self.nowPlayingSongIndex);
    if (indexPath.row == self.nowPlayingSongIndex) {
        NSLog(@"Configuring the playback cell controls...");
        [playMarker setHidden:NO];        
        [playMarker startAnimating];
        self.playbackActivityIndicatorView = playMarker;        
        self.playbackProgressView = (UIProgressView*)[cell viewWithTag:11];
        [self.playbackProgressView setHidden:NO];
    }
    else {
        NSLog(@"Configuring a cell that is not playing...");
        [playMarker stopAnimating];
        [playMarker setHidden:YES];
        [[cell viewWithTag:11] setHidden:YES];
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[JJManager sharedInstance] removeSongAtIndex:indexPath.row];        
        // Delete the row from the data source
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    JJManager.sharedInstance.currentSong = indexPath.row;
}

#pragma mark - JJManagerDelegate implementation

- (void)roomsChanged
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)playListReceived
{
    [self.tableView reloadData];
}

- (void)nowPlayingSong:(NSString *)song onAlbum:(NSString *)album atIndex:(NSInteger)index
{
    self.songLabel.text = [NSString stringWithFormat:@"%@ - %@", song, album];    
    self.nowPlayingSongIndex = index;
    [self.tableView reloadData];
}

- (void)receivedStreamDuration:(int)duration
{
    self.duration = duration;
    self.playbackProgressSlider.value = (float)self.position / (float)self.duration;
}

-(void)didUpdateCurrentPlaybackPosition:(int)position
{
    if (position > self.duration) {
        return;
    }
    
    self.position = position;
    
    int minutes;
    int seconds;
    int timeInMilliseconds;
    
    timeInMilliseconds = (self.duration - self.position) / 1000;
    seconds = timeInMilliseconds % 60;
    minutes = timeInMilliseconds / 60;
    self.playbackTimeRemainingLabel.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];

    timeInMilliseconds = self.position / 1000;
    seconds = timeInMilliseconds % 60;
    minutes = timeInMilliseconds / 60;
    self.currentPlaybackPositionLabel.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];

    if (self.duration > 0) {
        float progress = (float)self.position / (float)self.duration;
        NSLog(@"Progress=%f",progress);
        self.playbackProgressSlider.value = progress;
        [self.playbackProgressView setProgress:progress];
    }
}

- (void)didUpdatePlaybackStatus:(JJPlaybackStatus)status
{
    if (status == kJJPlaybackStatusPlaying) {
        [self.playbackActivityIndicatorView startAnimating];
    }
    else {
        [self.playbackActivityIndicatorView stopAnimating];
    }
}

#pragma mark - UI event handlers

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.willShowSongDetails = YES;
}

- (IBAction)didTouchPlayButton:(id)sender 
{
    [JJManager.sharedInstance play];
}

- (IBAction)didTouchStopButton:(id)sender 
{
    [JJManager.sharedInstance stop];
    [self.playbackActivityIndicatorView stopAnimating];
}

- (IBAction)didTouchPauseButton:(id)sender 
{
    [JJManager.sharedInstance pause];    
}

- (IBAction)didTouchAddSongButton:(id)sender 
{

}

- (IBAction)didTouchVolumeUpButton:(id)sender 
{
    [JJManager.sharedInstance volumeUp];
}

- (IBAction)didTouchVolumeDownButton:(id)sender 
{
    [JJManager.sharedInstance volumeDown];
}

- (IBAction)didTouchEditButton:(id)sender 
{
    if (self.tableView.isEditing) {
        [self.tableView setEditing:NO];
        self.editButton.title = @"Edit";
        self.editButton.style = UIBarButtonItemStyleBordered;
    }
    else {
        [self.tableView setEditing:YES];
        self.editButton.style = UIBarButtonItemStyleDone;
        self.editButton.title = @"Done";
    }
}

- (IBAction)playbackSliderPositionDidChange:(id)sender 
{
    NSInteger newPosition = (NSInteger)((float)self.duration * self.playbackProgressSlider.value);
    
    [[JJManager sharedInstance] seekTo:newPosition];
}

@end
