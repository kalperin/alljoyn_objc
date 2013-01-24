////////////////////////////////////////////////////////////////////////////////
// Copyright 2013, Qualcomm Innovation Center, Inc.
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
////////////////////////////////////////////////////////////////////////////////
//
//  ALLJOYN MODELING TOOL - GENERATED CODE
//
////////////////////////////////////////////////////////////////////////////////
//
//  DO NOT EDIT
//
//  Add a category or subclass in separate .h/.m files to extend these classes
//
////////////////////////////////////////////////////////////////////////////////
//
//  AJNPerformanceObject.h
//
////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>
#import "AJNBusAttachment.h"
#import "AJNBusInterface.h"
#import "AJNProxyBusObject.h"


////////////////////////////////////////////////////////////////////////////////
//
// PerformanceObjectDelegate Bus Interface
//
////////////////////////////////////////////////////////////////////////////////

@protocol PerformanceObjectDelegate <AJNBusInterface>


// methods
//
- (BOOL)checkPacketAtIndex:(NSNumber*)packetIndex payLoad:(AJNMessageArgument*)byteArray packetSize:(NSNumber*)packetSize message:(AJNMessage *)methodCallMessage;

// signals
//
- (void)sendPacketAtIndex:(NSNumber*)packetIndex payLoad:(AJNMessageArgument*)byteArray inSession:(AJNSessionId)sessionId toDestination:(NSString*)destinationPath flags:(AJNMessageFlag)flags;


@end

////////////////////////////////////////////////////////////////////////////////

    
////////////////////////////////////////////////////////////////////////////////
//
// PerformanceObjectDelegate Signal Handler Protocol
//
////////////////////////////////////////////////////////////////////////////////

@protocol PerformanceObjectDelegateSignalHandler <AJNSignalHandler>

// signals
//
- (void)didReceivePacketAtIndex:(NSNumber*)packetIndex payLoad:(AJNMessageArgument*)byteArray inSession:(AJNSessionId)sessionId message:(AJNMessage *)signalMessage;


@end

@interface AJNBusAttachment(PerformanceObjectDelegate)

- (void)registerPerformanceObjectDelegateSignalHandler:(id<PerformanceObjectDelegateSignalHandler>)signalHandler;

@end

////////////////////////////////////////////////////////////////////////////////
    

////////////////////////////////////////////////////////////////////////////////
//
//  AJNPerformanceObject Bus Object superclass
//
////////////////////////////////////////////////////////////////////////////////

@interface AJNPerformanceObject : AJNBusObject<PerformanceObjectDelegate>

// properties
//


// methods
//
- (BOOL)checkPacketAtIndex:(NSNumber*)packetIndex payLoad:(AJNMessageArgument*)byteArray packetSize:(NSNumber*)packetSize message:(AJNMessage *)methodCallMessage;


// signals
//
- (void)sendPacketAtIndex:(NSNumber*)packetIndex payLoad:(AJNMessageArgument*)byteArray inSession:(AJNSessionId)sessionId toDestination:(NSString*)destinationPath flags:(AJNMessageFlag)flags;


@end

////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////
//
//  PerformanceObject Proxy
//
////////////////////////////////////////////////////////////////////////////////

@interface PerformanceObjectProxy : AJNProxyBusObject

// properties
//


// methods
//
- (BOOL)checkPacketAtIndex:(NSNumber*)packetIndex payLoad:(AJNMessageArgument*)byteArray packetSize:(NSNumber*)packetSize;


@end

////////////////////////////////////////////////////////////////////////////////
