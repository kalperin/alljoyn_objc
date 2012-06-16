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
}

@property (nonatomic, strong) NSMutableArray *theRooms;
@property (nonatomic, strong) JamJoynServiceObjectProxy *jamjoynService;
@property (nonatomic, strong) AJNJamJoynServiceObject *serviceObject;
@property (nonatomic, strong) MediaSessionPortListener *mediaSessionListener;
@property (nonatomic) AJNSessionId sessionId;
@property (nonatomic) BOOL isPlaying;
@property (nonatomic, strong) NSString *mediaPath;

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
        
        musicFileReader = new MP3Reader();       
        
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
    return self;
}

- (void)sendSong
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Toccata_And_Fugue_In_D_Minor_CLAS_0001_02101" ofType:@"mp3"];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:path];
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
    song->songPath = [[@"STREAM:" stringByAppendingString:path] UTF8String];
    song->fileName = [@"Toccata_And_Fugue_In_D_Minor_CLAS_0001_02101.mp3" UTF8String];
    song->busId = [self.bus.uniqueIdentifier UTF8String];
    
    [self.jamjoynService sendSongs:song];
}

-(void)openAudioStream
{
    // create the audio stream and add it to the source
    //
    NSLog(@"Opening %@ file...", self.mediaPath);
    audioStream = new AudioStream(*((BusAttachment*)self.bus.handle), "mp3", *musicFileReader, 100, 1000);
    QStatus status = mediaSource->AddStream(*audioStream);

    NSLog(@"Open media file complete");    
}

- (void)joinRoom:(NSInteger)roomIndex
{
    NSString *room = [self.theRooms objectAtIndex:roomIndex];
    
    AJNSessionOptions *sessionOptions = [[AJNSessionOptions alloc] initWithTrafficType:kAJNTrafficMessages supportsMultipoint:YES proximity:kAJNProximityAny transportMask:kAJNTransportMaskAny];
    
    self.sessionId = [self.bus joinSessionWithName:room onPort:kServicePort withDelegate:self options:sessionOptions];
    
    [self.serviceObject announceNickName:@"iOS_R0x0r" isHost:NO inSession:self.sessionId toDestination:nil];
    
    self.jamjoynService = [[JamJoynServiceObjectProxy alloc] initWithBusAttachment:self.bus serviceName:room objectPath:kServicePath sessionId:self.sessionId];    
    
    [self.jamjoynService introspectRemoteObject];
    
    [self sendSong];
}

- (void)leaveRoom
{
    [self.bus leaveSession:self.sessionId];
    
    if (audioStream) {
        mediaSource->RemoveStream(*audioStream);
        delete audioStream;
        audioStream = nil;
    }    
    
    self.mediaPath = nil;
    self.sessionId = -1;
}

- (void)play
{
    JJSong *song = self.playlist + self.currentSong;
    NSString *argument;
    if (!self.isPlaying) {
        argument = [NSString stringWithFormat:@"%s|-|%s", song->songName.c_str(), song->album.c_str()];
    }
    [self.jamjoynService sendCommand:@"playSong" argument:argument];
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
    
    [self.delegate roomsChanged];
    
}

- (void)didLoseAdvertisedName:(NSString*)name withTransportMask:(AJNTransportMask)transport namePrefix:(NSString*)namePrefix
{
    NSLog(@"JJManager::didLoseAdvertisedName:%@ withTransportMask:%i namePrefix:%@", name, transport, namePrefix);
    
    [self.delegate roomsChanged];
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
    currentPlaylist = songs;
    playlistSongCount = songCount;
    
    [self.delegate playListReceived];
}

- (void)announcementReceived
{
    [self.jamjoynService sendCommand:@"setPlayList" argument:nil];        
}

- (void)receivedCommand:(NSString *)command withArguments:(NSString *)arguments
{
    if ([command compare:@"changePlayPauseStatus"] == NSOrderedSame) {
        if ([arguments compare:@"play"] == NSOrderedSame) {
            self.isPlaying = false;
            NSLog(@"Play state set to FALSE");
        }
        else if ([arguments compare:@"pause"] == NSOrderedSame) {
            self.isPlaying = true;
            NSLog(@"Play state set to TRUE");
        }
    }
    else if ([command compare:@"startStreamSong"] == NSOrderedSame) {
                
        // begin streaming the song to the player
        //
        NSArray *argumentTokens = [arguments componentsSeparatedByString:@"|"];
        self.mediaPath = [argumentTokens objectAtIndex:0];
        NSString *wellKnownName = [NSString stringWithFormat:@"org.alljoyn.Media.Server%@",[argumentTokens objectAtIndex:1]];

        // create the media playback objects so the music file can be streamed
        //
        QStatus status = musicFileReader->SetFile([self.mediaPath UTF8String]);
        
        if (audioStream) {
            mediaSource->RemoveStream(*audioStream);
            delete audioStream;
        }

        // create a new session for this media server
        //
        [self.bus requestWellKnownName:wellKnownName withFlags:kAJNBusNameFlagDoNotQueue | kAJNBusNameFlagAllowReplacement];        
        
        [self.bus advertiseName:wellKnownName withTransportMask:kAJNTransportMaskAny];
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
