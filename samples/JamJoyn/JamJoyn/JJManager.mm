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

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioServices.h>
#import "JJManager.h"
#import "JJConstants.h"
#import "JJService.h"
#import "JJMediaSource.h"
#import "JJMp3MediaStream.h"
#import <alljoyn/BusAttachment.h>
#import <ajstream/MP3Reader.h>
#import <ajstream/MediaSource.h>
#import <ajstream/MediaPacer.h>

using namespace ajn;

struct JJSong
{
    int32_t songId;
    qcc::String songPath;
    qcc::String songName;
    qcc::String artist;
    qcc::String album;
    int32_t albumId;
    qcc::String artPath;
    qcc::String fileName;
    qcc::String busId;    
};

class AudioStream : public MediaStream, MediaPacer {
    
public:
    
    AudioStream(BusAttachment& bus, const char* name, MP3Reader& reader, uint32_t jitter, uint32_t prefill) :
    MediaStream(bus, name, reader.GetDescription()),
    MediaPacer(reader.GetDescription(), jitter),
    reader(reader),
    prefill(prefill)
    {
        buffer = new uint8_t[reader.MaxFrameLen];
    }
    
    ~AudioStream()
    {
        MediaPacer::Stop();
        delete buffer;
    }
    
private:
    
    bool OnOpen(qcc::SocketFd sinkSocket)
    {
        QStatus status = reader.Open();
        if (status == ER_OK) {
            printf("Stream %s opened sock %u\n", GetStreamName().c_str(), sinkSocket);
            sock = sinkSocket;
            startTime = 0;
            timestamp = startTime;
            return true;
        } else {
            printf("Failed to open MP3\n");
            return false;
        }
    }
    
    void OnClose()
    {
        printf("Stream %s closed\n", GetStreamName().c_str());
        MediaPacer::Stop();
        reader.Close();
    }
    
    bool OnPlay()
    {
        printf("Stream %s play\n", GetStreamName().c_str());
        if (!IsRunning()) {
            MediaPacer::Start(sock, timestamp, prefill);
            return true;
        } else {
            return false;
        }
    }
    
    bool OnPause()
    {
        printf("Stream %s pause\n", GetStreamName().c_str());
        if (IsRunning()) {
            MediaPacer::Stop();
            return true;
        } else {
            return false;
        }
    }
    
    bool OnSeekRelative(int32_t offset, MediaSeekUnits units)
    {
        printf("Stream %s seek relative %d\n", GetStreamName().c_str(), offset);
        if (MediaPacer::IsRunning()) {
            MediaPacer::Stop();
        }
        QStatus status = reader.SetPosRelative(offset, units);
        if (status == ER_OK) {
            timestamp = startTime + reader.GetTimestamp();
            printf("Starting Stream on Socket=%u, timestamp=%u, prefill=%u\n", sock, timestamp, prefill);
            MediaPacer::Start(sock, timestamp, prefill);
            return true;
        }
        printf("SetPosAbsolute failed %s\n", QCC_StatusText(status));
        return false;
    }
    
    bool OnSeekAbsolute(uint32_t position, MediaSeekUnits units)
    {
        printf("Stream %s seek absolute %u\n", GetStreamName().c_str(), position);
        if (MediaPacer::IsRunning()) {
            MediaPacer::Stop();
        }
        QStatus status = reader.SetPosAbsolute(position, units);
        if (status == ER_OK) {
            timestamp = startTime + reader.GetTimestamp();
            printf("Starting Stream on Socket=%u, timestamp=%u, prefill=%u\n", sock, timestamp, prefill);
            MediaPacer::Start(sock, timestamp, prefill);
            return true;
        }
        printf("SetPosAbsolute failed %s\n", QCC_StatusText(status));
        return false;
    }
    
    void JitterMiss(uint32_t timestamp, qcc::SocketFd socket, uint32_t jitter)
    {
        printf("Failed to meet jitter target - actual jitter = %d\n", jitter);
    }
    
    QStatus RequestFrames(uint32_t timestamp, qcc::SocketFd socket, size_t maxFrames, size_t& count)
    {
        QStatus status = ER_OK;
        
        for (count = 0; (count < maxFrames) && (status == ER_OK); ++count) {
            size_t len;
            bool lostSync;
            status = reader.ReadFrame(buffer, reader.MaxFrameLen, len, lostSync);
            if (status == ER_OK) {
                if (lostSync) {
                    printf("Lost sync\n");
                }
                uint8_t*ptr = buffer;
                while (len) {
                    int ret = ::write(socket, ptr, len);
                    if (ret < 0) {
                        /* Write is blocking so EAGAIN or EBUSY means the output buffer is full */
                        if ((errno == EAGAIN) || (errno == EBUSY)) {
                            usleep(50 * 1000);
                            continue;
                        }
                        printf("write to %d failed with \"%s\"\n", socket, ::strerror(errno));
                        status = ER_WRITE_ERROR;
                        break;
                    }
                    printf("Wrote %d bytes\n", ret);
                    ptr += ret;
                    len -= ret;
                }
            }
        }
        /* Close the stream if the read or write failed */
        if (status != ER_OK) {
            Close();
        }
        return status;
    }
    
private:
    uint32_t startTime;   /* The timestamp corresponding to the start of the stream */
    uint32_t timestamp;   /* The timestamp for the current positition in the stream */
    qcc::SocketFd sock;   /* The socket to write the MP3 frame to */
    MP3Reader& reader;    /* The MP3 reader */
    uint8_t* buffer;
    uint32_t prefill;     /* Prefill milliseconds when starting a stream */
    
};

static JJManager *s_manager;

@interface AJNBusAttachment(Private)

@property (nonatomic, readonly) ajn::BusAttachment *busAttachment;

@end

@interface MediaSessionPortListener : NSObject <AJNSessionPortListener>

@end


@interface JJManager()<AJNBusListener, AJNSessionListener, AJNSessionPortListener, JamJoynServiceDelegate> {
    JJSong *currentPlaylist;
    MP3Reader *musicFileReader;
    MediaSource *mediaSource;
    AudioStream *audioStream;
    NSInteger playlistSongCount;
    float currentVolume;
}

@property (nonatomic, strong) NSMutableArray *theRooms;
@property (nonatomic, strong) JamJoynServiceObjectProxy *jamjoynService;
@property (nonatomic, strong) AJNJamJoynServiceObject *serviceObject;
@property (nonatomic, strong) MediaSessionPortListener *mediaSessionListener;
@property (nonatomic) AJNSessionId sessionId;
@property (nonatomic) BOOL isPlaying;
@property (nonatomic, strong) NSString *mediaPath;
@property (nonatomic, strong) NSMutableArray *peers;
@property (nonatomic, strong) NSString *songSessionName;

@property (nonatomic, strong) AJNBusAttachment *bus;

- (void)openAudioStream;

@end

@implementation JJManager

@synthesize theRooms = _theRooms;
@synthesize sessionId = _sessionId;
@synthesize delegate = _delegate;

@synthesize bus = _bus;
@synthesize jamjoynService = _jamjoynService;
@synthesize serviceObject = _serviceObject;
@synthesize mediaSessionListener = _mediaSessionListener;
@synthesize handle = _handle;
@synthesize currentRoom = _currentRoom;
@synthesize currentSong = _currentSong;
@synthesize isPlaying = _isPlaying;
@synthesize mediaPath = _mediaPath;
@synthesize peers = _peers;
@synthesize isStarted = _isStarted;
@synthesize songSessionName = _songSessionName;

- (NSArray *)rooms
{
    return [self.theRooms copy];
}

- (JJSong *)playlist
{
    return currentPlaylist;
}

- (NSInteger)playlistSongCount
{
    return playlistSongCount;
}

- (NSMutableArray *)peers
{
    if (_peers == nil) {
        _peers = [[NSMutableArray alloc] init];
    }
    return _peers;
}

- (NSMutableArray *)theRooms
{
    if (_theRooms == nil) {
        _theRooms = [[NSMutableArray alloc] init];
    }
    return _theRooms;
}

- (void)setCurrentRoom:(NSInteger)currentRoom
{
    _currentRoom = currentRoom;
    [self joinRoom:currentRoom];
}

- (id) init
{
    self = [super init];
    if (self) {
        
        [self startService];
        
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(volumeChanged:)
         name:@"AVSystemController_SystemVolumeDidChangeNotification"
         object:nil];
   }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)startService
{
    if (self.isStarted) {
        return;
    }
    _isStarted = YES;    
    
    self.mediaSessionListener = [[MediaSessionPortListener alloc] init];
    
    self.bus = [[AJNBusAttachment alloc] initWithApplicationName:kAppName allowingRemoteMessages:YES];
    
    [self.bus registerBusListener:self];
    
    [self.bus createInterfacesFromXml:kXMLInterfaceDescription];
    
    // start the bus and begin listening for bus traffic
    //
    [self.bus start];
    
    [self.bus connectWithArguments:@"null:"];
    
    // register signal handler
    //
    [self.bus registerJamJoynServiceObjectSignalHandler:self];
    
    self.serviceObject = [[AJNJamJoynServiceObject alloc] initWithBusAttachment:self.bus onPath:kServicePath];
    
    [self.bus registerBusObject:self.serviceObject];
    
    [self.bus findAdvertisedName:@"org.alljoyn.bus.samples.commandpasser"];    
    
    // media source session
    //
    AJNSessionOptions *sessionOptions = [[AJNSessionOptions alloc] initWithTrafficType:kAJNTrafficMessages supportsMultipoint:NO proximity:kAJNProximityAny transportMask:kAJNTransportMaskAny];
    
    mediaSource = new MediaSource(*((BusAttachment*)self.bus.handle));
    
    [self.bus registerBusObject:[[AJNBusObject alloc] initWithHandle:(AJNHandle)mediaSource]];
    
    [self.bus bindSessionOnPort:kMediaServicePort withOptions:sessionOptions withDelegate:self.mediaSessionListener];
}

- (void)stopService
{
    if (!self.isStarted) {
        return;
    }
    
    _isStarted = NO;
    
    [self.peers removeAllObjects];
    self.peers = nil;
    
    [self.bus unregisterBusObject:[[AJNBusObject alloc] initWithHandle:(AJNHandle)mediaSource]];
    
    [self.bus cancelFindAdvertisedName:@"org.alljoyn.bus.samples.commandpasser"];
    
    [self.bus unregisterBusObject:self.serviceObject];
    
    [self.bus unregisterSignalHandler:self];
    
    [self.bus disconnectWithArguments:@"null:"];
    
    [self.bus stop];
    
    [self.bus unregisterBusListener:self];
    
    if (mediaSource) {
        delete mediaSource;
        mediaSource = nil;
    }
    self.serviceObject = nil;
    self.mediaSessionListener = nil;    
    self.bus = nil;
}

- (void)sendSongNamed:(NSString*)songName
{
    NSString *songPath = [[NSBundle mainBundle] pathForResource:songName ofType:@"mp3"];
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
    
    JJSong *song = new JJSong();
    
    song->album = [[metaDataLookup valueForKey:@"albumName"] UTF8String];
    song->albumId = 0;
    song->artist = [[metaDataLookup valueForKey:@"creator"] UTF8String];
    song->songId = 0;
    song->songName = [[metaDataLookup valueForKey:@"title"] UTF8String];
    song->songPath = [[@"STREAM:" stringByAppendingString:songPath] UTF8String];
    song->fileName = [[songPath lastPathComponent] UTF8String];
    song->busId = [self.bus.uniqueIdentifier UTF8String];
    
    [self.jamjoynService sendSongs:song];
}

- (void)removeSongAtIndex:(NSInteger)index
{
    if (self.currentSong == index && audioStream) {
        audioStream->Close();
    }
    playlistSongCount--;
    self.currentSong = 0;
    [self.jamjoynService sendCommand:@"removeSong" argument:[NSString stringWithFormat:@"%u", index]];
    
}

-(void)openAudioStream
{
    // create the audio stream and add it to the source
    //
    NSLog(@"Opening %@ file...", self.mediaPath);
    audioStream = new AudioStream(*((BusAttachment*)self.bus.handle), "mp3", *musicFileReader, 100, 100);
    QStatus status = mediaSource->AddStream(*audioStream);
    if (status != ER_OK) {
        NSLog(@"ERROR: Failed to add stream to media source.");
    }
    else {
        NSLog(@"Open media file complete");    
    }
}

- (void)joinRoom:(NSInteger)roomIndex
{
    NSString *room = [self.theRooms objectAtIndex:roomIndex];
    
    AJNSessionOptions *sessionOptions = [[AJNSessionOptions alloc] initWithTrafficType:kAJNTrafficMessages supportsMultipoint:YES proximity:kAJNProximityAny transportMask:kAJNTransportMaskAny];
    
    self.sessionId = [self.bus joinSessionWithName:room onPort:kServicePort withDelegate:self options:sessionOptions];
    
    if (self.sessionId != -1) {
        [self.serviceObject announceNickName:@"iOS_R0x0r" isHost:NO inSession:self.sessionId toDestination:nil];
        
        self.jamjoynService = [[JamJoynServiceObjectProxy alloc] initWithBusAttachment:self.bus serviceName:room objectPath:kServicePath sessionId:self.sessionId];    
        
        [self.jamjoynService introspectRemoteObject];
    }
}

- (void)leaveRoom
{
    [self.bus leaveSession:self.sessionId];
    
    if (audioStream) {
        audioStream->Close();
        mediaSource->RemoveStream(*audioStream);
        delete audioStream;
        audioStream = nil;
    }    
    
    self.mediaPath = nil;
    self.sessionId = -1;
}

- (void)play
{
    if (self.playlistSongCount) {
        if (self.currentSong >= self.playlistSongCount) {
            self.currentSong = 0;
        }
        JJSong *song = self.playlist + self.currentSong;
        NSString *argument;

        argument = [NSString stringWithFormat:@"%s|-|%s", song->songName.c_str(), song->album.c_str()];

        [self.jamjoynService sendCommand:@"playSong" argument:argument];
    }
}

- (void)stop
{
    [self.jamjoynService sendCommand:@"stopSong" argument:nil];    
    self.isPlaying = FALSE;
}

- (void)pause
{
    [self.jamjoynService sendCommand:@"pauseSong" argument:nil];        
}

- (void)volumeChanged:(NSNotification *)notification
{
    float volume = [[[notification userInfo] objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
    
    NSLog(@"Volume changed to %f", volume);    
    
    float delta = volume - currentVolume;
    
    if (delta > 0 || volume == 1.0) {
        [self volumeUp];
    }
    else if (delta < 0 || volume == 0.0) {
        [self volumeDown];
    }

    currentVolume = volume;
}

- (void)volumeUp
{
    [self.jamjoynService sendCommand:@"changeVolume" argument:@"up"];
}

- (void)volumeDown
{
    [self.jamjoynService sendCommand:@"changeVolume" argument:@"down"];    
}

- (void)seekTo:(NSInteger)position
{
    NSLog(@"Seek to %i", position);
    [self.jamjoynService sendCommand:@"seekToLocation" argument:[NSString stringWithFormat:@"%i", position]];
}

#pragma mark - AJNBusListener delegate methods

- (void)didFindAdvertisedName:(NSString *)name withTransportMask:(AJNTransportMask)transport namePrefix:(NSString *)namePrefix
{
    NSLog(@"JJManager::didFindAdvertisedName:%@ withTransportMask:%i namePrefix:%@", name, transport, namePrefix);
    
    NSString *jjSessionName = [NSString stringWithFormat:@"%@", [[name componentsSeparatedByString:@"."] objectAtIndex:5]];
    
    NSLog(@"Discovered JamJoyn session: \"%@\"\n", jjSessionName);
    
    @synchronized(self.theRooms) {
        if (![self.theRooms containsObject:name]) {
            NSLog(@"JamJoyn session for %@ not found. Adding to dictionary...", jjSessionName);
            
            [self.theRooms addObject:name];
        }
        
    }
    
    if ([self.delegate respondsToSelector:@selector(roomsChanged)]) {
        [self.delegate roomsChanged];
    }
}

- (void)didLoseAdvertisedName:(NSString*)name withTransportMask:(AJNTransportMask)transport namePrefix:(NSString*)namePrefix
{
    NSLog(@"JJManager::didLoseAdvertisedName:%@ withTransportMask:%i namePrefix:%@", name, transport, namePrefix);
    
    @synchronized(self.theRooms) {
        if ([self.theRooms containsObject:name]) {
            NSLog(@"JamJoyn session will be removed for %@.", name);
            
            [self.theRooms removeObject:name];
        }
        
    }

    if ([self.delegate respondsToSelector:@selector(roomsChanged)]) {
        [self.delegate roomsChanged];
    }
}

- (void)nameOwnerChanged:(NSString *)name to:(NSString *)newOwner from:(NSString *)previousOwner
{
    NSLog(@"JJManager::nameOwnerChanged:%@ to:%@ namePrefix:%@", name, newOwner, previousOwner);    
}

#pragma mark - AJNSessionPortListener delegate methods

- (void)didJoin:(NSString *)joiner inSessionWithId:(AJNSessionId)sessionId onSessionPort:(AJNSessionPort)sessionPort
{
    NSLog(@"JJManager::didJoin:%@ inSessionWithId:%u onSessionPort:%u", joiner, sessionId, sessionPort);    
}

- (BOOL)shouldAcceptSessionJoinerNamed:(NSString *)joiner onSessionPort:(AJNSessionPort)sessionPort withSessionOptions:(AJNSessionOptions *)options
{
    NSLog(@"JJManager::shouldAcceptSessionJoinerNamed:%@ onSessionPort:%u", joiner, sessionPort);        
    return sessionPort == kServicePort;
}

#pragma mark - AJNSessionListener delegate methods

- (void)sessionWasLost:(AJNSessionId)sessionId
{
    NSLog(@"JJManager::sessionWasLost:%u", sessionId);            
}

- (void)didAddMemberNamed:(NSString*)memberName toSession:(AJNSessionId)sessionId
{
    NSLog(@"JJManager::didAddMemberNamed:%@ toSession:%u", memberName, sessionId);  
}

- (void)didRemoveMemberNamed:(NSString*)memberName fromSession:(AJNSessionId)sessionId
{
    NSLog(@"JJManager::didRemoveMemberNamed:%@ fromSession:%u", memberName, sessionId);                    
}

#pragma mark - JamJoynServiceDelegate

- (void)receiveSongList:(JJSong *)songs size:(long)songCount
{
    NSLog(@"Received a play list with %ld songs", songCount);
    
    currentPlaylist = songs;
    playlistSongCount = songCount;
    
    if ([self.delegate respondsToSelector:@selector(playListReceived)]) {
        [self.delegate playListReceived];
    }
}

- (void)announcementReceivedFromSender:(NSString *)sender withNickName:(NSString *)nickName isHost:(BOOL)isHost
{
    NSLog(@"Announcement received from %@ aka %@ isHost=%@. My bus name is %@.", sender, nickName, isHost ? @"YES" : @"NO", self.bus.uniqueName);
    
    // do not bother sending the playlist to ourselves
    //
    if ([sender compare:self.bus.uniqueName] == NSOrderedSame) {
        return;
    }
    
    [self.jamjoynService sendCommand:@"setPlayList" argument:nil];        
    
    JamJoynServiceObjectProxy *jamjoynPeer = [[JamJoynServiceObjectProxy alloc] initWithBusAttachment:self.bus serviceName:sender objectPath:kServicePath sessionId:self.sessionId];

    [self.peers addObject:jamjoynPeer];
}

- (void)receivedCommand:(NSString *)command withArguments:(NSString *)arguments
{
    NSLog(@"Received command %@ with arguments %@", command, arguments);
    
    if ([command compare:@"changePlayPauseStatus"] == NSOrderedSame) {
        NSLog(@"Playback status changed to %@", arguments);
        JJPlaybackStatus playbackStatus;
        if ([arguments compare:@"play"] == NSOrderedSame) {
            self.isPlaying = false;
            playbackStatus = kJJPlaybackStatusPaused;
            NSLog(@"Play state set to FALSE");
        }
        else if ([arguments compare:@"pause"] == NSOrderedSame) {
            self.isPlaying = true;
            playbackStatus = kJJPlaybackStatusPlaying;
            NSLog(@"Play state set to TRUE");
        }
        if ([self.delegate respondsToSelector:@selector(didUpdatePlaybackStatus:)]) {
            [self.delegate didUpdatePlaybackStatus:playbackStatus];
        }
    }
    else if ([command compare:@"startStreamSong"] == NSOrderedSame) {
        
        // cancel the advertised name before requesting a new name for the playback
        // session
        //
        if (self.songSessionName) {
            [self.bus cancelAdvertisedName:self.songSessionName withTransportMask:kAJNTransportMaskAny];        
        }
        
        // begin streaming the song to the player
        //
        NSArray *argumentTokens = [arguments componentsSeparatedByString:@"|"];
        self.mediaPath = [argumentTokens objectAtIndex:0];
        self.songSessionName = [NSString stringWithFormat:@"org.alljoyn.Media.Server%@",[argumentTokens objectAtIndex:1]];
        NSLog(@"Start streaming %@ from %@", self.mediaPath, self.songSessionName);                
        
        // create the MP3 reader
        //
        if (musicFileReader) {
            delete musicFileReader;
            musicFileReader = nil;
        }
        musicFileReader = new MP3Reader();               
        
        // create the media playback objects so the music file can be streamed
        //
        @try {
            QStatus status = musicFileReader->SetFile([self.mediaPath UTF8String]);
            if (status != ER_OK) {
                NSLog(@"ERROR: Failed to set the file used by the MP3 reader.");
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Exception: caught exception!!!");
        }
        @finally {
            
        }
        
        if (audioStream) {
            mediaSource->RemoveStream(*audioStream);
            delete audioStream;
            audioStream = nil;
        }

        // create a new session for this media server
        //
        [self.bus requestWellKnownName:self.songSessionName withFlags:kAJNBusNameFlagDoNotQueue | kAJNBusNameFlagAllowReplacement];        
        
        [self.bus advertiseName:self.songSessionName withTransportMask:kAJNTransportMaskAny];
    }
    else if ([command compare:@"setCurrentTime"] == NSOrderedSame) {
        if ([self.delegate respondsToSelector:@selector(didUpdateCurrentPlaybackPosition:)]) {
            [self.delegate didUpdateCurrentPlaybackPosition:[arguments intValue]];
        }
    }
    else if ([command compare:@"setDuration"] == NSOrderedSame) {
        if ([self.delegate respondsToSelector:@selector(receivedStreamDuration:)]) {
            [self.delegate receivedStreamDuration:[arguments intValue]];
        }
    }
    else if ([command compare:@"nowPlaying"] == NSOrderedSame) {
        if ([self.delegate respondsToSelector:@selector(nowPlayingSong:onAlbum:atIndex:)]) {
            NSArray *tokens = [arguments componentsSeparatedByString:@"|-|"];
            if (tokens.count == 2) {
                NSString *nowPlayingSong = [tokens objectAtIndex:0];
                NSString *nowPlayingAlbum = [tokens objectAtIndex:1];
                NSInteger nowPlayingSongIndex = -1;
                for (int i = 0; i < self.playlistSongCount; i++) {
                    NSString *songName = [NSString stringWithCString:self.playlist[i].songName.c_str() encoding:NSUTF8StringEncoding];
                    NSString *albumName = [NSString stringWithCString:self.playlist[i].album.c_str() encoding:NSUTF8StringEncoding];
                    if ([songName compare:nowPlayingSong] == NSOrderedSame &&
                        [albumName compare:nowPlayingAlbum] == NSOrderedSame) {
                        nowPlayingSongIndex = i;
                        break;
                    }
                }
                NSLog(@"Now playing song %@ with index %i of album %@", nowPlayingSong, nowPlayingSongIndex, nowPlayingAlbum);
                [self.delegate nowPlayingSong:nowPlayingSong onAlbum:nowPlayingAlbum atIndex:nowPlayingSongIndex];                
            }
        }
    }
    else if ([command compare:@"sendSongList"] == NSOrderedSame) {
        
        // send songs available on this device to everyone in the room
        //
        
    }
}

#pragma mark - Class methods

+ (void)initialize
{
    @synchronized(self) {
        if (s_manager == nil) {
            s_manager = [[JJManager alloc] init];
        }
    }
}

+ (JJManager*)sharedInstance
{
    @synchronized(self) {
        return s_manager;
    }
}


@end

@implementation MediaSessionPortListener

- (BOOL)shouldAcceptSessionJoinerNamed:(NSString *)joiner onSessionPort:(AJNSessionPort)sessionPort withSessionOptions:(AJNSessionOptions *)options
{
    NSLog(@"Media session accept called.");
    [[JJManager sharedInstance] openAudioStream];
    return true;
}

- (void)didJoin:(NSString *)joiner inSessionWithId:(AJNSessionId)sessionId onSessionPort:(AJNSessionPort)sessionPort
{
    NSLog(@"Media session did join!");
}

@end
