//
//  JJAddSongViewController.m
//  JamJoyn
//
//  Created by  on 6/19/12.
//  Copyright (c) 2012 2012 Qualcomm Innovation Center, Inc. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "JJAddSongViewController.h"
#import "JJManager.h"

@interface JJAddSongViewController ()

@property (nonatomic, strong) NSArray *allMusic;

@end

@implementation JJAddSongViewController

@synthesize allMusic = _allMusic;

- (NSArray *)allMusic
{
    if (_allMusic == nil) {
        NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *bundleDirectoryContents = [fileManager contentsOfDirectoryAtPath:bundlePath error:nil];
        NSPredicate *filter = [NSPredicate predicateWithFormat:@"self ENDSWITH '.mp3'"];
        NSArray *musicFiles = [bundleDirectoryContents filteredArrayUsingPredicate:filter];        
        _allMusic = [musicFiles copy];
    }
    return _allMusic;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
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
    return self.allMusic.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"songCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSString *songResource = [[[self.allMusic objectAtIndex:indexPath.row] componentsSeparatedByString:@"."] objectAtIndex:0];
    NSString *songPath = [[NSBundle mainBundle] pathForResource:songResource ofType:@"mp3"];
    
    NSURL *url = [[NSURL alloc] initFileURLWithPath:songPath];
    AVAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];    
    NSArray *metadata = [asset commonMetadata];
    NSMutableDictionary *metaDataLookup = [[NSMutableDictionary alloc] init];
    
    for ( AVMetadataItem* item in metadata ) {
        NSString *key = [item commonKey];
        NSString *value = [item stringValue];
        NSLog(@"key = %@, value = %@", key, value);
        [metaDataLookup setValue:value forKey:key];
    }

    UIImageView *albumImageView = (UIImageView*)[cell viewWithTag:1];
    UILabel *artistNameLabel = (UILabel*)[cell viewWithTag:3];
    UILabel *songNameLabel = (UILabel*)[cell viewWithTag:2];
    UILabel *albumTitleLabel = (UILabel*)[cell viewWithTag:4];
    UILabel *descriptionLabel = (UILabel*)[cell viewWithTag:5];

    NSString *albumPrefix = [[[songPath lastPathComponent] componentsSeparatedByString:@"\\"] objectAtIndex:0];
    NSString *imageDirectory = [songPath stringByDeletingLastPathComponent];
    NSArray *bundleDirectoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:imageDirectory error:nil];
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"self ENDSWITH '.jpg'"];
    NSArray *jpgFiles = [bundleDirectoryContents filteredArrayUsingPredicate:filter];        
    NSString *jpgFile;
    for (NSString *jpgFileName in jpgFiles) {
        if ([jpgFileName hasPrefix:albumPrefix]) {
            jpgFile = jpgFileName;
            break;
        }
    }

    albumImageView.image = [UIImage imageNamed:jpgFile];
    albumTitleLabel.text = [metaDataLookup valueForKey:@"albumName"];
    artistNameLabel.text = [metaDataLookup valueForKey:@"creator"];
    songNameLabel.text = [metaDataLookup valueForKey:@"title"];
    descriptionLabel.text = [metaDataLookup valueForKey:@"description"];
    
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

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
}

- (IBAction)didTouchDoneButton:(id)sender 
{
    NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
    for (NSIndexPath *indexPath in selectedRows) {
        NSString *songName = [[[self.allMusic objectAtIndex:indexPath.row] componentsSeparatedByString:@"."] objectAtIndex:0];
        [[JJManager sharedInstance] sendSongNamed:songName];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
