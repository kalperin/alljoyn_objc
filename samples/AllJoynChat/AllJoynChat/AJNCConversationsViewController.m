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

#import "AJNCConversationsViewController.h"
#import "AJNCNewChatSessionViewController.h"
#import "AJNCConversationViewController.h"
#import "AJNCChatManager.h"
#import "AJNCConversationViewCell.h"

@interface AJNCConversationsViewController ()<NewChatSessionDelegate, AJNCChatManagerDelegate>

- (void)didAddNewSessionNamed:(NSString *)newSessionName;

@end

@implementation AJNCConversationsViewController

@synthesize messageToastView = _messageToastView;

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

	// Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.messageToastView];
    self.messageToastView.hidden = YES;
}

- (void)viewDidUnload
{
    [self setMessageToastView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AJNCChatManager.sharedInstance.delegate = self;
    [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"Segue %@", segue.identifier);
    if ([segue.identifier compare:@"displayNewChatSessionView"] == NSOrderedSame) {
        AJNCNewChatSessionViewController *viewController = segue.destinationViewController;
        viewController.delegate = self;
    }
    else if ([segue.identifier compare:@"displayConversationView"] == NSOrderedSame){
        AJNCConversationViewController *viewController = segue.destinationViewController;
        viewController.conversation = [AJNCChatManager.sharedInstance conversationAtIndex:self.tableView.indexPathForSelectedRow.row];
    }
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
    return AJNCChatManager.sharedInstance.conversationsCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"sessionCell";
    AJNCConversationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[AJNCConversationViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    AJNCConversation *conversation = [AJNCChatManager.sharedInstance conversationAtIndex:indexPath.row];
    cell.summary = [NSString stringWithFormat:@"%@ (%i)", conversation.displayName, conversation.totalParticipants];
    cell.detail = conversation.name;
    cell.badgeText = [NSString stringWithFormat:@"%i", conversation.messages.count];
    cell.badgeColor = [UIColor orangeColor];
    cell.badgeHighlightColor = [UIColor lightGrayColor];
    
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
    AJNCConversation *conversation = [AJNCChatManager.sharedInstance conversationAtIndex:indexPath.row];
    
    NSLog(@"Selected session named: %@", conversation.displayName);
    
    if (conversation && conversation.identifier == 0) {
        [AJNCChatManager.sharedInstance joinConversation:conversation];        
    }
}

#pragma mark - NewChatSessionDelegate delegate methods

- (void)didAddNewSessionNamed:(NSString *)newSessionName
{
    [AJNCChatManager.sharedInstance addConversationNamed:newSessionName];
    
    [self.tableView reloadData];
}

#pragma mark - AJNCChatManagerDelegate methods

- (void)didReceiveNewMessage:(AJNCMessage*)message
{
    [self.tableView reloadData];
    [self.tableView setNeedsDisplay];
    
    UILabel *titleLabel = (UILabel*)[self.messageToastView viewWithTag:1];
    UILabel *messageLabel = (UILabel*)[self.messageToastView viewWithTag:2];    
    
    titleLabel.text = [NSString stringWithFormat:@"New message from %@",message.senderName];
    messageLabel.text = message.text;
    
    self.messageToastView.frame = CGRectMake(0, 0, self.messageToastView.frame.size.width, self.messageToastView.frame.size.height);
    self.messageToastView.hidden = NO;
    self.messageToastView.alpha = 1;
    
    [UIView animateWithDuration:3 delay:0 options:UIViewAnimationCurveEaseIn animations:^{
        
        [self.view bringSubviewToFront:self.messageToastView];
        self.messageToastView.frame = CGRectMake(0, self.view.frame.size.height - self.messageToastView.frame.size.height, self.messageToastView.frame.size.width, self.messageToastView.frame.size.height);
        self.messageToastView.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        self.messageToastView.hidden = YES;
        self.messageToastView.frame = CGRectMake(0, 0, self.messageToastView.frame.size.width, self.messageToastView.frame.size.height);
        
    }];
    
}

- (void)didUpdateConversations
{
    [self.tableView reloadData];
    [self.tableView setNeedsDisplay];
}

@end
