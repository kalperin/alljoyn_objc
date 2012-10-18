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
//  AJNPingObject.h
//
////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>
#import "AJNBusAttachment.h"
#import "AJNBusInterface.h"
#import "AJNProxyBusObject.h"


////////////////////////////////////////////////////////////////////////////////
//
// PingObjectDelegate Bus Interface
//
////////////////////////////////////////////////////////////////////////////////

@protocol PingObjectDelegate <AJNBusInterface>


// methods
//
- (NSString*)sendPingString:(NSString*)outStr withDelay:(NSNumber*)delay;
- (NSString*)sendPingString:(NSString*)outStr;
- (void)sendPingAtTimeInSeconds:(NSNumber*)sendTimeSecs timeInMilliseconds:(NSNumber*)sendTimeMillisecs receivedTimeInSeconds:(NSNumber**)receivedTimeSecs receivedTimeInMilliseconds:(NSNumber**)receivedTimeMillisecs;

// signals
//
- (void)sendmy_signalInSession:(AJNSessionId)sessionId toDestination:(NSString*)destinationPath;


@end

////////////////////////////////////////////////////////////////////////////////

    
////////////////////////////////////////////////////////////////////////////////
//
// PingObjectDelegate Signal Handler Protocol
//
////////////////////////////////////////////////////////////////////////////////

@protocol PingObjectDelegateSignalHandler <AJNSignalHandler>

// signals
//
- (void)didReceivemy_signalInSession:(AJNSessionId)sessionId fromSender:(NSString*)sender;


@end

@interface AJNBusAttachment(PingObjectDelegate)

- (void)registerPingObjectDelegateSignalHandler:(id<PingObjectDelegateSignalHandler>)signalHandler;

@end

////////////////////////////////////////////////////////////////////////////////
    

////////////////////////////////////////////////////////////////////////////////
//
// PingObjectValuesDelegate Bus Interface
//
////////////////////////////////////////////////////////////////////////////////

@protocol PingObjectValuesDelegate <AJNBusInterface>


// properties
//
@property (nonatomic, strong) NSNumber* int_val;
@property (nonatomic, readonly) NSString* ro_str;
@property (nonatomic, strong) NSString* str_val;


@end

////////////////////////////////////////////////////////////////////////////////

    

////////////////////////////////////////////////////////////////////////////////
//
//  AJNPingObject Bus Object superclass
//
////////////////////////////////////////////////////////////////////////////////

@interface AJNPingObject : AJNBusObject<PingObjectDelegate, PingObjectValuesDelegate>

// properties
//
@property (nonatomic, strong) NSNumber* int_val;
@property (nonatomic, readonly) NSString* ro_str;
@property (nonatomic, strong) NSString* str_val;


// methods
//
- (NSString*)sendPingString:(NSString*)outStr withDelay:(NSNumber*)delay;
- (NSString*)sendPingString:(NSString*)outStr;
- (void)sendPingAtTimeInSeconds:(NSNumber*)sendTimeSecs timeInMilliseconds:(NSNumber*)sendTimeMillisecs receivedTimeInSeconds:(NSNumber**)receivedTimeSecs receivedTimeInMilliseconds:(NSNumber**)receivedTimeMillisecs;


// signals
//
- (void)sendmy_signalInSession:(AJNSessionId)sessionId toDestination:(NSString*)destinationPath;


@end

////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////
//
//  PingObject Proxy
//
////////////////////////////////////////////////////////////////////////////////

@interface PingObjectProxy : AJNProxyBusObject

// properties
//
@property (nonatomic, strong) NSNumber* int_val;
@property (nonatomic, readonly) NSString* ro_str;
@property (nonatomic, strong) NSString* str_val;


// methods
//
- (NSString*)sendPingString:(NSString*)outStr withDelay:(NSNumber*)delay;
- (NSString*)sendPingString:(NSString*)outStr;
- (void)sendPingAtTimeInSeconds:(NSNumber*)sendTimeSecs timeInMilliseconds:(NSNumber*)sendTimeMillisecs receivedTimeInSeconds:(NSNumber**)receivedTimeSecs receivedTimeInMilliseconds:(NSNumber**)receivedTimeMillisecs;


@end

////////////////////////////////////////////////////////////////////////////////
