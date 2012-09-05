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

#import "AJNCConversationViewController.h"
#import "AJNCChatManager.h"
#import "AJNCMessage.h"

@interface AJNCConversationViewController () <AJNCChatManagerDelegate>



@end

@implementation AJNCConversationViewController

@synthesize messageTextField = _messageTextField;
@synthesize conversation = _session;
@synthesize tableView = _tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
    
    [self.messageTextField becomeFirstResponder];
}

- (void)viewDidUnload
{
    [self setMessageTextField:nil];
    [self setTableView:nil];    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.title = self.conversation.displayName;
    AJNCChatManager.sharedInstance.delegate = self;
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (self.conversation.messages.count > 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.conversation.messages.count - 1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];    
    }
    
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.conversation.chatObject.delegate = self.conversation;
    [AJNCChatManager.sharedInstance stop];
    [super viewWillDisappear:animated];
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
    return self.conversation.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"messageCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UILabel *senderLabel = (UILabel*)[cell viewWithTag:1];
    UILabel *dateTimeLabel = (UILabel*)[cell viewWithTag:2];
    UITextView *messageTextView = (UITextView*)[cell viewWithTag:3];
    AJNCMessage *message = [self.conversation.messages objectAtIndex:indexPath.row];
    
    senderLabel.text = message.senderName;
    dateTimeLabel.text = message.dateTime;
    messageTextView.text = message.text;
    
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

- (IBAction)didTouchSendButton:(id)sender 
{
    if (self.conversation == nil && AJNCChatManager.sharedInstance.conversationsCount) {
        self.conversation = [AJNCChatManager.sharedInstance conversationAtIndex:0];
        [self.tableView reloadData];
    }
    
    NSLog(@"%@",self.conversation);
    
    [self.conversation.chatObject sendChatMessage:self.messageTextField.text onSession:self.conversation.identifier];
    [AJNCChatManager.sharedInstance chatMessageReceived:self.messageTextField.text from:@"Me" onObjectPath:@"local" forSession:self.conversation.identifier];
    self.messageTextField.text = @"";    
}

- (void)chatMessageReceived:(NSString *)message from:(NSString *)sender onObjectPath:(NSString *)path forSession:(AJNSessionId)sessionId
{
    if (self.conversation == nil && AJNCChatManager.sharedInstance.conversationsCount) {
        self.conversation = [AJNCChatManager.sharedInstance conversationAtIndex:0];
        [self.tableView reloadData];
    }
    
    [self.tableView reloadData];
    NSLog(@"%@",self.conversation);    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.conversation.messages.count - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)didReceiveNewMessage:(AJNCMessage*)message
{
    if (self.conversation == nil && AJNCChatManager.sharedInstance.conversationsCount) {
        self.conversation = [AJNCChatManager.sharedInstance conversationAtIndex:0];
        [self.tableView reloadData];
    }
    
    [self.tableView reloadData];
    NSLog(@"%@",self.conversation);
    if (self.conversation.messages.count) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.conversation.messages.count - 1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

@end
