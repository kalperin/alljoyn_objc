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
//  AJNBasicObject.h
//
////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>
#import "AJNBusAttachment.h"
#import "AJNBusInterface.h"
#import "AJNProxyBusObject.h"
#import "AJNSignalHandlerImpl.h"

struct JJSong;

////////////////////////////////////////////////////////////////////////////////
//
// JamJoynService Bus Interface
//
////////////////////////////////////////////////////////////////////////////////

@protocol JamJoynService <AJNBusInterface>


// methods
//
- (void)sendCommand:(NSString*)command argument:(NSString*)arg;
- (void)setSongFileName:(NSString*)filename titleName:(NSString*)title albumName:(NSString*)album artistName:(NSString*)artist numberOfChunks:(NSNumber*)numChunks chunkIndex:(NSNumber*)chunkIndex bytes:(char *)bytes;
- (void)sendMySongs:(JJSong *)songs;
- (void)sendSongs:(JJSong *)song;

// signals
//
- (void)didReceiveCommand:(NSString*)command argument:(NSString*)arg inSession:(AJNSessionId)sessionId toDestination:(NSString*)destinationPath;
- (void)announceNickName:(NSString*)nickName isHost:(BOOL)isHost inSession:(AJNSessionId)sessionId toDestination:(NSString*)destinationPath;
- (void)setPlaylistSongs:(JJSong *)songs inSession:(AJNSessionId)sessionId toDestination:(NSString*)destinationPath;


@end

////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////
//
//  AJNJamJoynServiceObject Bus Object superclass
//
////////////////////////////////////////////////////////////////////////////////

@interface AJNJamJoynServiceObject : AJNBusObject<JamJoynService>

// properties
//


// methods
//
- (void)sendCommand:(NSString*)command argument:(NSString*)arg;
- (void)setSongFileName:(NSString*)filename titleName:(NSString*)title albumName:(NSString*)album artistName:(NSString*)artist numberOfChunks:(NSNumber*)numChunks chunkIndex:(NSNumber*)chunkIndex bytes:(char *)bytes;
- (void)sendMySongs:(JJSong *)songs;
- (void)sendSongs:(JJSong *)song;


// signals
//
- (void)didReceiveCommand:(NSString*)command argument:(NSString*)arg inSession:(AJNSessionId)sessionId toDestination:(NSString*)destinationPath;
- (void)announceNickName:(NSString*)nickName isHost:(BOOL)isHost inSession:(AJNSessionId)sessionId toDestination:(NSString*)destinationPath;
- (void)setPlaylistSongs:(JJSong *)songs inSession:(AJNSessionId)sessionId toDestination:(NSString*)destinationPath;


@end

////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////
//
//  JamJoynServiceObject Proxy
//
////////////////////////////////////////////////////////////////////////////////

@interface JamJoynServiceObjectProxy : AJNProxyBusObject

// properties
//


// methods
//
- (void)sendCommand:(NSString*)command argument:(NSString*)arg;
- (void)setSongFileName:(NSString*)filename titleName:(NSString*)title albumName:(NSString*)album artistName:(NSString*)artist numberOfChunks:(NSNumber*)numChunks chunkIndex:(NSNumber*)chunkIndex bytes:(char *)bytes;
- (void)sendMySongs:(JJSong *)songs;
- (void)sendSongs:(JJSong *)song;


@end

////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
//  Signal Handler for JamJoynServiceObject
//
////////////////////////////////////////////////////////////////////////////////

@protocol JamJoynServiceDelegate <AJNSignalHandler>

- (void)receiveSongList:(JJSong*)songs size:(long)songCount;
- (void)announcementReceivedFromSender:(NSString*)sender withNickName:(NSString*)nickName isHost:(BOOL)isHost;
- (void)receivedCommand:(NSString*)command withArguments:(NSString*)arguments;

@end

@interface AJNBusAttachment(JamJoynServiceDelegate)

- (void)registerJamJoynServiceObjectSignalHandler:(id<JamJoynServiceDelegate>)signalHandler;

@end

////////////////////////////////////////////////////////////////////////////////