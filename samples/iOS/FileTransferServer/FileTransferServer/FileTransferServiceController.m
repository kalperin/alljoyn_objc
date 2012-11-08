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

#import "FileTransferServiceController.h"
#import "FileTransferObject.h"
#import "Constants.h"

@implementation FileTransferServiceController

@synthesize applicationName = _applicationName;
@synthesize object = _object;
@synthesize name = _name;
@synthesize nameFlags = _nameFlags;
@synthesize port = _port;

- (id)init
{
    self = [super init];
    if (self) {
        self.delegate = self;
        self.applicationName = kAppName;
        self.name = kServiceName;
        self.nameFlags = kAJNBusNameFlagReplaceExisting | kAJNBusNameFlagDoNotQueue;
        self.port = kServicePort;
    }
    return self;
}

- (AJNBusObject *)objectOnBus:(AJNBusAttachment *)bus
{
    self.object = [[FileTransferObject alloc] initWithBusAttachment:bus onPath:kServicePath];
    return self.object;
}

- (void)shouldUnloadObjectOnBus:(AJNBusAttachment *)bus
{
    self.object = nil;
}

@end
