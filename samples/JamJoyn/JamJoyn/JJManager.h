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

#import <Foundation/Foundation.h>

struct JJSong;

@protocol JJManagerDelegate <NSObject>

- (void)roomsChanged;
- (void)playListReceived;

@end

@interface JJManager : NSObject

@property (readonly, nonatomic) NSArray *rooms;
@property (nonatomic) NSInteger currentRoom;
@property (readonly, nonatomic) struct JJSong *playlist;
@property (readonly, nonatomic) NSInteger playlistSongCount;
@property (nonatomic) NSInteger currentSong;
@property (nonatomic, strong) id<JJManagerDelegate> delegate;

- (void)joinRoom:(NSInteger)roomIndex;

- (void)play;
- (void)stop;
- (void)pause;

+ (JJManager *)sharedInstance;

@end
