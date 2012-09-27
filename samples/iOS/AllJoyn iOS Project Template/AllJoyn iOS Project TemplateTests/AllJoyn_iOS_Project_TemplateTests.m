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

#import "AllJoyn_iOS_Project_TemplateTests.h"
#import "SampleClient.h"
#import "SampleService.h"

@interface AllJoyn_iOS_Project_TemplateTests() <SampleClientDelegate>

@property (nonatomic, strong) SampleClient *sampleClient;
@property (nonatomic, strong) SampleService *sampleService;
@property (nonatomic) BOOL clientFoundService;

@end

@implementation AllJoyn_iOS_Project_TemplateTests

@synthesize sampleClient = _sampleClient;
@synthesize sampleService = _sampleService;
@synthesize clientFoundService = _clientFoundService;

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    //
    self.clientFoundService = NO;
    
    self.sampleClient = [[SampleClient alloc] initWithDelegate:self];
    self.sampleService = [[SampleService alloc] init];
    
    [self.sampleService start];
    [self.sampleClient start];
}

- (void)tearDown
{
    // Tear-down code here.
    //
    [self.sampleClient stop];
    [self.sampleService stop];
    self.clientFoundService = NO;
    
    [super tearDown];
}

- (void)testClientShouldBeAbleToConcatenateStringsUsingService
{
    // wait a bit until the client connects to the service
    //
    STAssertTrue([self waitForCompletion:15 onFlag:&_clientFoundService], @"The client failed to connect to the service in a timely manner.");
    
    // call the service and ask it to concatenate the strings together, then
    // verify the result of the method call.
    //
    NSString *concatenatedString = [self.sampleClient callServiceToConcatenateString:@"Hello" withString:@" AllJoyn World!!!!!!"];
    STAssertTrue(concatenatedString != nil, @"The returned string was nil");
    STAssertTrue([concatenatedString compare:@"Hello AllJoyn World!!!!!!"] == NSOrderedSame, @"The string returned to the client <%@> was not correctly concatenated by the service.", concatenatedString);
    
}

#pragma mark - Asynchronous test case support

- (BOOL)waitForCompletion:(NSTimeInterval)timeoutSeconds onFlag:(BOOL*)flag
{
    NSDate *timeoutDate = [NSDate dateWithTimeIntervalSinceNow:timeoutSeconds];
    
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:timeoutDate];
        if ([timeoutDate timeIntervalSinceNow] < 0.0) {
            break;
        }
    } while (!*flag);
    
    return *flag;
}

#pragma mark - SampleClientDelegate implementation

- (void)didConnectWithService
{
    self.clientFoundService = YES;
}

@end
