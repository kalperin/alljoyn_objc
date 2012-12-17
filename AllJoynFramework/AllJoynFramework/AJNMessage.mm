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

#import <alljoyn/Message.h>
#import "AJNMessage.h"
#import "AJNMessageArgument.h"

using namespace ajn;

////////////////////////////////////////////////////////////////////////////////
//
// Constants
//

/** No reply is expected*/
const AJNMessageFlag kAJNMessageFlagNoReplyExpected     = 0x01;
/** Auto start the service */
const AJNMessageFlag kAJNMessageFlagAutoStart           = 0x02;
/** Allow messages from remote hosts (valid only in Hello message) */
const AJNMessageFlag kAJNMessageFlagAllowRemoteMessages = 0x04;
/** Sessionless message  */
const AJNMessageFlag kAJNMessageFlagSessionless         = 0x10;
/** Global (bus-to-bus) broadcast */
const AJNMessageFlag kAJNMessageFlagGlobalBroadcast     = 0x20;
/** Header is compressed */
const AJNMessageFlag kAJNMessageFlagCompressed          = 0x40;
/** Body is encrypted */
const AJNMessageFlag kAJNMessageFlagEncrypted           = 0x80;

////////////////////////////////////////////////////////////////////////////////

@interface AJNObject(Private)

@property (nonatomic) BOOL shouldDeleteHandleOnDealloc;

@end

@interface AJNMessage()

/**
 * Helper to return the C++ API object that is encapsulated by this objective-c class
 */
@property (nonatomic, readonly) _Message *message;

@end

@implementation AJNMessage

/**
 * Helper to return the C++ API object that is encapsulated by this objective-c class
 */
- (_Message*)message
{
    return static_cast<Message*>(self.handle)->operator->();
}

- (BOOL)isBroadcastSignal
{
    return self.message->IsBroadcastSignal();
}

- (BOOL)isGlobalBroadcast
{
    return self.message->IsGlobalBroadcast();
}

- (AJNMessageFlag)flags
{
    return self.message->GetFlags();
}

- (BOOL)isExpired
{
    return self.message->IsExpired();
}

- (uint32_t)timeUntilExpiration
{
    uint32_t time;
    self.message->IsExpired(&time);
    return time;
}

- (BOOL)isUnreliable
{
    return self.message->IsUnreliable();
}

- (BOOL)isEncrypted
{
    return self.message->IsEncrypted();
}

- (NSString*)authenticationMechanism
{
    return [NSString stringWithCString:self.message->GetAuthMechanism().c_str() encoding:NSUTF8StringEncoding];
}

- (AJNMessageType)type
{
    return (AJNMessageType)self.message->GetType();
}

- (NSArray*)arguments
{
    size_t argCount;
    const MsgArg *args;
    self.message->GetArgs(argCount, args);
    NSMutableArray *arguments = [[NSMutableArray alloc] initWithCapacity:argCount];
    for (int i = 0; i < argCount; i++) {
        [arguments addObject:[[AJNMessageArgument alloc] initWithHandle:(AJNHandle)&(args[i])]];
    }
    return arguments;
}

- (uint32_t)callSerialNumber
{
    return self.message->GetCallSerial();
}

- (AJNMessageHeaderFields *)headerFields 
{
    return [[AJNMessageHeaderFields alloc] initWithHandle:(AJNHandle)(&(self.message->GetHeaderFields()))];
}

- (uint32_t)replySerialNumber
{
    return self.message->GetReplySerial();
}

- (NSString *)signature
{
    return [NSString stringWithCString:self.message->GetSignature() encoding:NSUTF8StringEncoding];
}

- (NSString *)objectPath
{
    return [NSString stringWithCString:self.message->GetObjectPath() encoding:NSUTF8StringEncoding];
}

- (NSString *)interfaceName
{
    return [NSString stringWithCString:self.message->GetInterface() encoding:NSUTF8StringEncoding];
}

- (NSString *)memberName
{
    return [NSString stringWithCString:self.message->GetMemberName() encoding:NSUTF8StringEncoding];
}

- (NSString *)senderName
{
    return [NSString stringWithCString:self.message->GetSender() encoding:NSUTF8StringEncoding];
}

- (NSString *)receiverEndpointName
{
    return [NSString stringWithCString:self.message->GetRcvEndpointName() encoding:NSUTF8StringEncoding];
}

- (NSString *)destination
{
    return [NSString stringWithCString:self.message->GetDestination() encoding:NSUTF8StringEncoding];
}

- (uint32_t)compressionToken
{
    return self.message->GetCompressionToken();
}

- (uint32_t)sessionId
{
    return self.message->GetSessionId();
}

- (NSString *)errorName
{
    return [NSString stringWithCString:self.message->GetErrorName() encoding:NSUTF8StringEncoding];
}

- (NSString *)errorDescription
{
    qcc::String errorDescriptionString;
    self.message->GetErrorName(&errorDescriptionString);
    return [NSString stringWithCString:errorDescriptionString.c_str() encoding:NSUTF8StringEncoding];
}

- (NSString *)description
{
    return [NSString stringWithCString:self.message->Description().c_str() encoding:NSUTF8StringEncoding];
}

- (NSString *)xmlDescription
{
    return [NSString stringWithCString:self.message->ToString().c_str() encoding:NSUTF8StringEncoding];
}

- (uint32_t)timeStamp
{
    return self.message->GetTimeStamp();
}

- (void)dealloc
{
    if (self.shouldDeleteHandleOnDealloc) {
        if (self.message)
        {
            delete self.message;
        }
        self.handle = nil;
    }
}

@end
