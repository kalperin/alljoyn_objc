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

#import "BasicSampleObject.h"
#import "BasicSampleObjectImpl.h"
#import "AJNInterfaceDescription.h"

@implementation MyBasicSampleObject

@synthesize delegate = _delegate;

- (BasicSampleObjectImpl*)busObject
{
    return (BasicSampleObjectImpl*)self.handle;
}

- (id)initWithBusAttachment:(AJNBusAttachment *)busAttachment onPath:(NSString *)path
{
    self = [super initWithBusAttachment:busAttachment onPath:path];
    if (self) {
        BOOL result;
        
        AJNInterfaceDescription *interfaceDescription;
        
        // create an interface description and add the concatenate method to it
        //
        interfaceDescription = [busAttachment createInterfaceWithName:kBasicObjectInterfaceName];
        
        result = [interfaceDescription addMethodWithName:kBasicObjectMethodName inputSignature:@"ss" outputSignature:@"s" argumentNames:[NSArray arrayWithObjects:@"str1", @"str2", @"outStr", nil]];
        
        if (result != ER_OK) {
            [self.delegate didReceiveStatusUpdateMessage:@"Failed to create interface 'org.alljoyn.Bus.method_sample'\n"];
            
            @throw [NSException exceptionWithName:@"BusObjectInitFailed" reason:@"Unable to add method to interface" userInfo:nil];
        }
        [self.delegate didReceiveStatusUpdateMessage:@"Interface Created.\n"];        
        
        [interfaceDescription activate];
        
        // create the internal C++ bus object
        //
        BasicSampleObjectImpl *busObject = new BasicSampleObjectImpl(*((ajn::BusAttachment*)busAttachment.handle), [path UTF8String], (id<MyMethodSample>)self);
        
        self.handle = busObject;
    }
    return self;
}

- (void)dealloc
{
    BasicSampleObjectImpl *busObject = [self busObject];
    delete busObject;
    self.handle = nil;
}

- (void)objectWasRegistered
{
    [self.delegate didReceiveStatusUpdateMessage:@"MyBasicSampleObject was registered.\n"];
}

@end
