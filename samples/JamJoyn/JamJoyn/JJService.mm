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
//  AJNBasicObject.mm
//
////////////////////////////////////////////////////////////////////////////////

#import <alljoyn/BusAttachment.h>
#import <alljoyn/BusObject.h>
#import "AJNBusObjectImpl.h"
#import "AJNInterfaceDescription.h"

#import "JJConstants.h"
#import "JJService.h"

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

using namespace ajn;


////////////////////////////////////////////////////////////////////////////////
//
//  C++ Bus Object class declaration for JamJoynServiceObjectImpl
//
////////////////////////////////////////////////////////////////////////////////
class JamJoynServiceObjectImpl : public AJNBusObjectImpl
{
private:
    const InterfaceDescription::Member* CommandSignalSignalMember;
	const InterfaceDescription::Member* AnnounceSignalMember;
	const InterfaceDescription::Member* SetPlaylistSongsSignalMember;

    
public:
    JamJoynServiceObjectImpl(BusAttachment &bus, const char *path, id<JamJoynService> aDelegate);

    
    
    // methods
    //
    void Command(const InterfaceDescription::Member* member, Message& msg);
	void SetByteData(const InterfaceDescription::Member* member, Message& msg);
	void sendMySongs(const InterfaceDescription::Member* member, Message& msg);
	void sendSongInfo(const InterfaceDescription::Member* member, Message& msg);

    
    // signals
    //
    QStatus SendCommandSignal(const char * command,const char * arg, const char* destination, SessionId sessionId, uint16_t timeToLive = 0, uint8_t flags = 0);
	QStatus SendAnnounce(const char * nickName,bool isHost, const char* destination, SessionId sessionId, uint16_t timeToLive = 0, uint8_t flags = 0);
	QStatus SendSetPlaylistSongs(JJSong *songs, const char* destination, SessionId sessionId, uint16_t timeToLive = 0, uint8_t flags = 0);

};
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
//  C++ Bus Object implementation for JamJoynServiceObjectImpl
//
////////////////////////////////////////////////////////////////////////////////

JamJoynServiceObjectImpl::JamJoynServiceObjectImpl(BusAttachment &bus, const char *path, id<JamJoynService> aDelegate) : 
    AJNBusObjectImpl(bus,path,aDelegate)
{
    const InterfaceDescription* interfaceDescription = NULL;
    QStatus status = ER_OK;
    
    
    // Add the JamJoynService interface to this object
    //
    interfaceDescription = bus.GetInterface("org.alljoyn.bus.samples.commandpasser");
    assert(interfaceDescription);
    AddInterface(*interfaceDescription);

    
    // Register the method handlers for interface JamJoynService with the object
    //
    const MethodEntry methodEntriesForJamJoynService[] = {

        {
			interfaceDescription->GetMember("Command"), static_cast<MessageReceiver::MethodHandler>(&JamJoynServiceObjectImpl::Command)
		},

		{
			interfaceDescription->GetMember("SetByteData"), static_cast<MessageReceiver::MethodHandler>(&JamJoynServiceObjectImpl::SetByteData)
		},

		{
			interfaceDescription->GetMember("sendMySongs"), static_cast<MessageReceiver::MethodHandler>(&JamJoynServiceObjectImpl::sendMySongs)
		},

		{
			interfaceDescription->GetMember("sendSongInfo"), static_cast<MessageReceiver::MethodHandler>(&JamJoynServiceObjectImpl::sendSongInfo)
		}
    
    };
    
    status = AddMethodHandlers(methodEntriesForJamJoynService, sizeof(methodEntriesForJamJoynService) / sizeof(methodEntriesForJamJoynService[0]));
    if (ER_OK != status) {
        // TODO: perform error checking here
    }
    
    // save off signal members for later
    //
    CommandSignalSignalMember = interfaceDescription->GetMember("CommandSignal");
    assert(CommandSignalSignalMember);    
AnnounceSignalMember = interfaceDescription->GetMember("Announce");
    assert(AnnounceSignalMember);    
SetPlaylistSongsSignalMember = interfaceDescription->GetMember("SetPlaylistSongs");
    assert(SetPlaylistSongsSignalMember);    


}


void JamJoynServiceObjectImpl::Command(const InterfaceDescription::Member *member, Message& msg)
{
    
    
    // get all input arguments
    //
    
    qcc::String inArg0 = msg->GetArg(0)->v_string.str;
        
    qcc::String inArg1 = msg->GetArg(1)->v_string.str;
        
    
    // call the Objective-C delegate method
    //
    
	[(id<JamJoynService>)delegate sendCommand:[NSString stringWithCString:inArg0.c_str() encoding:NSUTF8StringEncoding] argument:[NSString stringWithCString:inArg1.c_str() encoding:NSUTF8StringEncoding]];
}


void JamJoynServiceObjectImpl::SetByteData(const InterfaceDescription::Member *member, Message& msg)
{
    
    
    // get all input arguments
    //
    
//    qcc::String inArg0 = msg->GetArg(0)->v_string.str;
//        
//    qcc::String inArg1 = msg->GetArg(1)->v_string.str;
//        
//    qcc::String inArg2 = msg->GetArg(2)->v_string.str;
//        
//    qcc::String inArg3 = msg->GetArg(3)->v_string.str;
//        
//    int32_t inArg4 = msg->GetArg(4)->v_int32;
//        
//    int32_t inArg5 = msg->GetArg(5)->v_int32;
        
    
    // call the Objective-C delegate method
    //
    
//	[(id<JamJoynService>)delegate ];            
        
}


void JamJoynServiceObjectImpl::sendMySongs(const InterfaceDescription::Member *member, Message& msg)
{
    
    
    // get all input arguments
    //
    
    
    // call the Objective-C delegate method
    //
    
//	[(id<JamJoynService>)delegate ];            
        
}


void JamJoynServiceObjectImpl::sendSongInfo(const InterfaceDescription::Member *member, Message& msg)
{
    
    
    // get all input arguments
    //
    
    
    // call the Objective-C delegate method
    //
    
//	[(id<JamJoynService>)delegate ];            
        
}


QStatus JamJoynServiceObjectImpl::SendCommandSignal(const char * command,const char * arg, const char* destination, SessionId sessionId, uint16_t timeToLive, uint8_t flags)
{

    MsgArg args[2];

    
    args[0].Set( "s", command );

    args[1].Set( "s", arg );


    return Signal(destination, sessionId, *CommandSignalSignalMember, args, 2, timeToLive, flags);
}


QStatus JamJoynServiceObjectImpl::SendAnnounce(const char * nickName,bool isHost, const char* destination, SessionId sessionId, uint16_t timeToLive, uint8_t flags)
{

    MsgArg args[2];

    
    args[0].Set( "s", nickName );

    args[1].Set( "b", isHost );


    QStatus status = Signal(destination, sessionId, *AnnounceSignalMember, args, 2, timeToLive, flags);
    return status;
}


QStatus JamJoynServiceObjectImpl::SendSetPlaylistSongs(JJSong *songs, const char* destination, SessionId sessionId, uint16_t timeToLive, uint8_t flags)
{

    MsgArg args[1];

    
    args[0].Set( "a(sssssiiss)", 1, songs );


    return Signal(destination, sessionId, *SetPlaylistSongsSignalMember, args, 1, timeToLive, flags);
}



////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
//  Objective-C Bus Object implementation for AJNJamJoynServiceObject
//
////////////////////////////////////////////////////////////////////////////////

@implementation AJNJamJoynServiceObject

@dynamic handle;



- (JamJoynServiceObjectImpl*)busObject
{
    return static_cast<JamJoynServiceObjectImpl*>(self.handle);
}

- (id)initWithBusAttachment:(AJNBusAttachment *)busAttachment onPath:(NSString *)path
{
    self = [super initWithBusAttachment:busAttachment onPath:path];
    if (self) {
        QStatus status = ER_OK;
        
        AJNInterfaceDescription *interfaceDescription;
        
    
        //
        // JamJoynService interface (org.alljoyn.bus.samples.commandpasser)
        //
        // create an interface description
        //
        interfaceDescription = [busAttachment createInterfaceWithName:@"org.alljoyn.bus.samples.commandpasser"];

    
        // add the methods to the interface description
        //
    
        status = [interfaceDescription addMethodWithName:@"Command" inputSignature:@"ss" outputSignature:@"" argumentNames:[NSArray arrayWithObjects:@"command",@"arg", nil]];
        
        if (status != ER_OK && status != ER_BUS_MEMBER_ALREADY_EXISTS) {
            @throw [NSException exceptionWithName:@"BusObjectInitFailed" reason:@"Unable to add method to interface: Command" userInfo:nil];
        }

        status = [interfaceDescription addMethodWithName:@"SetByteData" inputSignature:@"ssssiiab" outputSignature:@"" argumentNames:[NSArray arrayWithObjects:@"filename",@"title",@"album",@"artist",@"numChunks",@"chunkIndex",@"bytes", nil]];
        
        if (status != ER_OK && status != ER_BUS_MEMBER_ALREADY_EXISTS) {
            @throw [NSException exceptionWithName:@"BusObjectInitFailed" reason:@"Unable to add method to interface: SetByteData" userInfo:nil];
        }

        status = [interfaceDescription addMethodWithName:@"sendMySongs" inputSignature:@"a(sssssiiss)" outputSignature:@"" argumentNames:[NSArray arrayWithObjects:@"songs", nil]];
        
        if (status != ER_OK && status != ER_BUS_MEMBER_ALREADY_EXISTS) {
            @throw [NSException exceptionWithName:@"BusObjectInitFailed" reason:@"Unable to add method to interface: sendMySongs" userInfo:nil];
        }

        status = [interfaceDescription addMethodWithName:@"sendSongInfo" inputSignature:@"(sssssiiss)" outputSignature:@"" argumentNames:[NSArray arrayWithObjects:@"song", nil]];
        
        if (status != ER_OK && status != ER_BUS_MEMBER_ALREADY_EXISTS) {
            @throw [NSException exceptionWithName:@"BusObjectInitFailed" reason:@"Unable to add method to interface: sendSongInfo" userInfo:nil];
        }

        // add the signals to the interface description
        //
    
        status = [interfaceDescription addSignalWithName:@"CommandSignal" inputSignature:@"" argumentNames:[NSArray arrayWithObjects:@"command",@"arg", nil]];
        
        if (status != ER_OK && status != ER_BUS_MEMBER_ALREADY_EXISTS) {
            @throw [NSException exceptionWithName:@"BusObjectInitFailed" reason:@"Unable to add signal to interface:  CommandSignal" userInfo:nil];
        }

        status = [interfaceDescription addSignalWithName:@"Announce" inputSignature:@"" argumentNames:[NSArray arrayWithObjects:@"nickName",@"isHost", nil]];
        
        if (status != ER_OK && status != ER_BUS_MEMBER_ALREADY_EXISTS) {
            @throw [NSException exceptionWithName:@"BusObjectInitFailed" reason:@"Unable to add signal to interface:  Announce" userInfo:nil];
        }

        status = [interfaceDescription addSignalWithName:@"SetPlaylistSongs" inputSignature:@"" argumentNames:[NSArray arrayWithObjects:@"songs", nil]];
        
        if (status != ER_OK && status != ER_BUS_MEMBER_ALREADY_EXISTS) {
            @throw [NSException exceptionWithName:@"BusObjectInitFailed" reason:@"Unable to add signal to interface:  SetPlaylistSongs" userInfo:nil];
        }

    
        [interfaceDescription activate];


        // create the internal C++ bus object
        //
        JamJoynServiceObjectImpl *busObject = new JamJoynServiceObjectImpl(*((ajn::BusAttachment*)busAttachment.handle), [path UTF8String], (id<JamJoynService>)self);
        
        self.handle = busObject;
    }
    return self;
}

- (void)dealloc
{
    JamJoynServiceObjectImpl *busObject = [self busObject];
    delete busObject;
    self.handle = nil;
}

    
- (void)sendCommand:(NSString*)command argument:(NSString*)arg
{
    //
    // GENERATED CODE - DO NOT EDIT
    //
    // Create a category or subclass in separate .h/.m files
    @throw([NSException exceptionWithName:@"NotImplementedException" reason:@"You must override this method in a subclass" userInfo:nil]);
}

- (void)setSongFileName:(NSString*)filename titleName:(NSString*)title albumName:(NSString*)album artistName:(NSString*)artist numberOfChunks:(NSNumber*)numChunks chunkIndex:(NSNumber*)chunkIndex bytes:(char *)bytes
{
    //
    // GENERATED CODE - DO NOT EDIT
    //
    // Create a category or subclass in separate .h/.m files
    @throw([NSException exceptionWithName:@"NotImplementedException" reason:@"You must override this method in a subclass" userInfo:nil]);
}

- (void)sendMySongs:(JJSong *)songs
{
    //
    // GENERATED CODE - DO NOT EDIT
    //
    // Create a category or subclass in separate .h/.m files
    @throw([NSException exceptionWithName:@"NotImplementedException" reason:@"You must override this method in a subclass" userInfo:nil]);
}

- (void)sendSongs:(JJSong *)song
{
    //
    // GENERATED CODE - DO NOT EDIT
    //
    // Create a category or subclass in separate .h/.m files
    @throw([NSException exceptionWithName:@"NotImplementedException" reason:@"You must override this method in a subclass" userInfo:nil]);
}

- (void)didReceiveCommand:(NSString*)command argument:(NSString*)arg inSession:(AJNSessionId)sessionId toDestination:(NSString*)destinationPath
{
    self.busObject->SendCommandSignal([command UTF8String], [arg UTF8String], [destinationPath UTF8String], sessionId);
}

- (void)announceNickName:(NSString*)nickName isHost:(BOOL)isHost inSession:(AJNSessionId)sessionId toDestination:(NSString*)destinationPath
{
    self.busObject->SendAnnounce([nickName UTF8String], isHost, [destinationPath UTF8String], sessionId);
}

- (void)setPlaylistSongs:(JJSong *)songs inSession:(AJNSessionId)sessionId toDestination:(NSString*)destinationPath
{
    self.busObject->SendSetPlaylistSongs(songs, [destinationPath UTF8String], sessionId);
}

    
@end

////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
//  Objective-C Proxy Bus Object implementation for JamJoynServiceObject
//
////////////////////////////////////////////////////////////////////////////////

@interface JamJoynServiceObjectProxy(Private)

@property (nonatomic, strong) AJNBusAttachment *bus;

- (ProxyBusObject*)proxyBusObject;

@end

@implementation JamJoynServiceObjectProxy
    
- (void)sendCommand:(NSString*)command argument:(NSString*)arg
{
    [self addInterfaceNamed:@"org.alljoyn.bus.samples.commandpasser"];
    
    // prepare the input arguments
    //
    
    Message reply(*((BusAttachment*)self.bus.handle));    
    MsgArg inArgs[2];
    
    inArgs[0].Set("s", [command UTF8String]);

    inArgs[1].Set("s", [arg UTF8String]);


    // make the function call using the C++ proxy object
    //
    QStatus status = self.proxyBusObject->MethodCall([@"org.alljoyn.bus.samples.commandpasser" UTF8String], "Command", inArgs, 2, reply, 5000);
    if (ER_OK == status) {
    
    }
    else {
    
    }

    

}

- (void)setSongFileName:(NSString*)filename titleName:(NSString*)title albumName:(NSString*)album artistName:(NSString*)artist numberOfChunks:(NSNumber*)numChunks chunkIndex:(NSNumber*)chunkIndex bytes:(char *)bytes
{
    [self addInterfaceNamed:@"org.alljoyn.bus.samples.commandpasser"];
    
    // prepare the input arguments
    //
    
    Message reply(*((BusAttachment*)self.bus.handle));    
    MsgArg inArgs[7];
    
    inArgs[0].Set("s", [filename UTF8String]);

    inArgs[1].Set("s", [title UTF8String]);

    inArgs[2].Set("s", [album UTF8String]);

    inArgs[3].Set("s", [artist UTF8String]);

    inArgs[4].Set("i", [numChunks intValue]);

    inArgs[5].Set("i", [chunkIndex intValue]);

    inArgs[6].Set("ab", bytes);


    // make the function call using the C++ proxy object
    //
    QStatus status = self.proxyBusObject->MethodCall([@"/commandPasserService" UTF8String], "SetByteData", inArgs, 7, reply, 5000);
    if (ER_OK == status) {
    
    }
    else {
    
    }

    

}

- (void)sendMySongs:(JJSong *)songs
{
    [self addInterfaceNamed:@"org.alljoyn.bus.samples.commandpasser"];
    
    // prepare the input arguments
    //
    
    Message reply(*((BusAttachment*)self.bus.handle));    
    MsgArg inArgs[1];
    
    inArgs[0].Set("a(sssssiiss)", 1, songs);


    // make the function call using the C++ proxy object
    //
    QStatus status = self.proxyBusObject->MethodCall([@"/commandPasserService" UTF8String], "sendMySongs", inArgs, 1, reply, 5000);
    if (ER_OK == status) {
    
    }
    else {
    
    }

    

}

- (void)sendSongs:(JJSong *)song
{
    [self addInterfaceNamed:@"org.alljoyn.bus.samples.commandpasser"];
    
    // prepare the input arguments
    //
    
    Message reply(*((BusAttachment*)self.bus.handle));    
    MsgArg inArgs[1];
    
    inArgs[0].Set("(sssssiiss)", song);


    // make the function call using the C++ proxy object
    //
    QStatus status = self.proxyBusObject->MethodCall([@"/commandPasserService" UTF8String], "sendSongInfo", inArgs, 1, reply, 5000);
    if (ER_OK == status) {
    
    }
    else {
    
    }

    

}

@end

////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////
//
//  C++ Signal Handler implementation for JamJoynServiceObject
//
////////////////////////////////////////////////////////////////////////////////

class JJServiceSignalHandlerImpl : public AJNSignalHandlerImpl
{
private:
    const ajn::InterfaceDescription::Member* setPlaylistSongs;
    const ajn::InterfaceDescription::Member* announce;    
    const ajn::InterfaceDescription::Member* commandSignal;        
    
    /** Receive a signal from another JJ service */
    void SetPlaylistSongsServiceSignalHandler(const ajn::InterfaceDescription::Member* member, const char* srcPath, ajn::Message& msg);
    void AnnounceServiceSignalHandler(const ajn::InterfaceDescription::Member* member, const char* srcPath, ajn::Message& msg);
    void CommandServiceSignalHandler(const ajn::InterfaceDescription::Member* member, const char* srcPath, ajn::Message& msg);
    
public:
    /**
     * Constructor for the AJN signal handler implementation.
     *
     * @param aDelegate         Objective C delegate called when one of the below virtual functions is called.     
     */    
    JJServiceSignalHandlerImpl(id<AJNSignalHandler> aDelegate);
    
    virtual void RegisterSignalHandler(ajn::BusAttachment &bus);
    
    virtual void UnregisterSignalHandler(ajn::BusAttachment &bus);
    
    /**
     * Virtual destructor for derivable class.
     */
    virtual ~JJServiceSignalHandlerImpl();
};


/**
 * Constructor for the AJN signal handler implementation.
 *
 * @param aDelegate         Objective C delegate called when one of the below virtual functions is called.     
 */    
JJServiceSignalHandlerImpl::JJServiceSignalHandlerImpl(id<AJNSignalHandler> aDelegate) : AJNSignalHandlerImpl(aDelegate)
{
    setPlaylistSongs = NULL;
    announce = NULL;
    commandSignal = NULL;
}

JJServiceSignalHandlerImpl::~JJServiceSignalHandlerImpl()
{
    m_delegate = NULL;
}

void JJServiceSignalHandlerImpl::RegisterSignalHandler(ajn::BusAttachment &bus)
{
    if (setPlaylistSongs == NULL) {
        const ajn::InterfaceDescription* interface = bus.GetInterface([kInterfaceName UTF8String]);
        
        /* Store the Chat signal member away so it can be quickly looked up */
        setPlaylistSongs = interface->GetMember("SetPlaylistSongs");
        assert(setPlaylistSongs);
    }
    
    /* Register signal handler */
    QStatus status =  bus.RegisterSignalHandler(this,
                                                static_cast<MessageReceiver::SignalHandler>(&JJServiceSignalHandlerImpl::SetPlaylistSongsServiceSignalHandler),
                                                setPlaylistSongs,
                                                NULL);
    if (status != ER_OK) {
        NSLog(@"ERROR:JJServiceSignalHandlerImpl::RegisterSignalHandler failed. %@", [AJNStatus descriptionForStatusCode:status] );
    }

    if (announce == NULL) {
        const ajn::InterfaceDescription* interface = bus.GetInterface([kInterfaceName UTF8String]);
        
        /* Store the Chat signal member away so it can be quickly looked up */
        announce = interface->GetMember("Announce");
        assert(announce);
    }
    /* Register signal handler */
    status =  bus.RegisterSignalHandler(this,
                                                static_cast<MessageReceiver::SignalHandler>(&JJServiceSignalHandlerImpl::AnnounceServiceSignalHandler),
                                                announce,
                                                NULL);
    if (status != ER_OK) {
        NSLog(@"ERROR:JJServiceSignalHandlerImpl::RegisterSignalHandler failed. %@", [AJNStatus descriptionForStatusCode:status] );
    }


    if (commandSignal == NULL) {
        const ajn::InterfaceDescription* interface = bus.GetInterface([kInterfaceName UTF8String]);
        
        /* Store the Chat signal member away so it can be quickly looked up */
        commandSignal = interface->GetMember("CommandSignal");
        assert(commandSignal);
    }
    /* Register signal handler */
    status =  bus.RegisterSignalHandler(this,
                                        static_cast<MessageReceiver::SignalHandler>(&JJServiceSignalHandlerImpl::CommandServiceSignalHandler),
                                        commandSignal,
                                        NULL);
    if (status != ER_OK) {
        NSLog(@"ERROR:JJServiceSignalHandlerImpl::RegisterSignalHandler failed. %@", [AJNStatus descriptionForStatusCode:status] );
    }
}

void JJServiceSignalHandlerImpl::UnregisterSignalHandler(ajn::BusAttachment &bus)
{
    if (setPlaylistSongs == NULL) {
        const ajn::InterfaceDescription* chatIntf = bus.GetInterface([kInterfaceName UTF8String]);
        
        setPlaylistSongs = chatIntf->GetMember("SetPlaylistSongs");
        assert(setPlaylistSongs);
    }
    /* Register signal handler */
    QStatus status =  bus.UnregisterSignalHandler(this, static_cast<MessageReceiver::SignalHandler>(&JJServiceSignalHandlerImpl::SetPlaylistSongsServiceSignalHandler), setPlaylistSongs, NULL);
    
    if (status != ER_OK) {
        NSLog(@"ERROR:JJServiceSignalHandlerImpl::UnregisterSignalHandler failed. %@", [AJNStatus descriptionForStatusCode:status] );
    }

    if (announce == NULL) {
        const ajn::InterfaceDescription* interface = bus.GetInterface([kInterfaceName UTF8String]);
        
        /* Store the Chat signal member away so it can be quickly looked up */
        announce = interface->GetMember("Announce");
        assert(announce);
    }
    /* Register signal handler */
    status =  bus.UnregisterSignalHandler(this, static_cast<MessageReceiver::SignalHandler>(&JJServiceSignalHandlerImpl::AnnounceServiceSignalHandler), announce, NULL);
    
    if (status != ER_OK) {
        NSLog(@"ERROR:JJServiceSignalHandlerImpl::UnregisterSignalHandler failed. %@", [AJNStatus descriptionForStatusCode:status] );
    }
}

void JJServiceSignalHandlerImpl::SetPlaylistSongsServiceSignalHandler(const ajn::InterfaceDescription::Member* member, const char* srcPath, ajn::Message& msg)
{
    @autoreleasepool {
        MsgArg *entries = NULL;
        long numEntries = 0;
        msg->GetArgs("a(sssssiiss)", &numEntries, &entries);
        NSString *from = [NSString stringWithCString:msg->GetSender() encoding:NSUTF8StringEncoding];
        NSString *objectPath = [NSString stringWithCString:msg->GetObjectPath() encoding:NSUTF8StringEncoding];
        
        NSLog(@"Received signal from %@ on path %@ for session id %u [%s > %s] this=%u", from, objectPath, msg->GetSessionId(), msg->GetRcvEndpointName(), msg->GetDestination() ? msg->GetDestination() : "broadcast", (uint)this);
        
        JJSong *songs = new JJSong[numEntries];
        for (int i = 0; i < numEntries; i++) {
            int32_t songId;
            const char* songPath;
            const char* songName;
            const char* artist;
            const char* album;
            int32_t albumId;
            const char* artPath;
            const char* fileName;
            const char* busId;
            
            entries[i].Get("(sssssiiss)", &songPath, &songName, &artist, &album, &artPath, &songId, &albumId, &fileName, &busId);
            
            songs[i].songId = songId;
            songs[i].songPath = songPath;
            songs[i].songName = songName;
            songs[i].artist = artist;
            songs[i].album = album;
            songs[i].albumId = albumId;
            songs[i].artPath = artPath;
            songs[i].fileName = fileName;
            songs[i].busId = busId;  // because busId can't be trusted (typically "ERROR")
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [(id<JamJoynServiceDelegate>)m_delegate receiveSongList:songs size:numEntries];
        });
        
    }
}    

void JJServiceSignalHandlerImpl::AnnounceServiceSignalHandler(const ajn::InterfaceDescription::Member* member, const char* srcPath, ajn::Message& msg)
{
    @autoreleasepool {
        NSString *from = [NSString stringWithCString:msg->GetSender() encoding:NSUTF8StringEncoding];
        NSString *objectPath = [NSString stringWithCString:msg->GetObjectPath() encoding:NSUTF8StringEncoding];
        
        NSLog(@"Received signal from %@ on path %@ for session id %u [%s > %s] this=%u", from, objectPath, msg->GetSessionId(), msg->GetRcvEndpointName(), msg->GetDestination() ? msg->GetDestination() : "broadcast", (uint)this);
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [(id<JamJoynServiceDelegate>)m_delegate announcementReceived];
        });
        
    }
}    

void JJServiceSignalHandlerImpl::CommandServiceSignalHandler(const ajn::InterfaceDescription::Member* member, const char* srcPath, ajn::Message& msg)
{
    @autoreleasepool {
        NSString *command = [NSString stringWithCString:msg->GetArg(0)->v_string.str encoding:NSUTF8StringEncoding];
        NSString *arguments = [NSString stringWithCString:msg->GetArg(1)->v_string.str encoding:NSUTF8StringEncoding];
        NSString *from = [NSString stringWithCString:msg->GetSender() encoding:NSUTF8StringEncoding];
        NSString *objectPath = [NSString stringWithCString:msg->GetObjectPath() encoding:NSUTF8StringEncoding];
        
        NSLog(@"Received signal from %@ on path %@ for session id %u [%s > %s] this=%u", from, objectPath, msg->GetSessionId(), msg->GetRcvEndpointName(), msg->GetDestination() ? msg->GetDestination() : "broadcast", (uint)this);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [(id<JamJoynServiceDelegate>)m_delegate receivedCommand:command withArguments:arguments];
        });
        
    }
}    

@implementation AJNBusAttachment(JamJoynServiceDelegate)

- (void)registerJamJoynServiceObjectSignalHandler:(id<JamJoynServiceDelegate>)signalHandler
{
    JJServiceSignalHandlerImpl *signalHandlerImpl = new JJServiceSignalHandlerImpl(signalHandler);
    signalHandler.handle = signalHandlerImpl;
    [self registerSignalHandler:signalHandler];
}

@end

