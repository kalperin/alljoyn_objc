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

#import <alljoyn/BusAttachment.h>
#import "AJNCBusObjectImpl.h"
#import "AJNCBusObject.h"
#import "AJNCConversation.h"
#import "AJNCConstants.h"

AJNCBusObjectImpl::AJNCBusObjectImpl(ajn::BusAttachment &bus, const char *path, id<AJNBusObject> aDelegate) : AJNBusObjectImpl(bus,path,aDelegate)
{
    const ajn::InterfaceDescription* chatIntf = bus.GetInterface([kInterfaceName UTF8String]);
    assert(chatIntf);
    AddInterface(*chatIntf);
    
    /* Store the Chat signal member away so it can be quickly looked up when signals are sent */
    chatSignalMember = chatIntf->GetMember("Chat");
    assert(chatSignalMember);
}

/* send a chat signal */
QStatus AJNCBusObjectImpl::SendChatSignal(const char* msg, ajn::SessionId sessionId) 
{
    NSLog(@"SendChatSignal( %s, %u)", msg, sessionId);
    
    ajn::MsgArg chatArg("s", msg);
    uint8_t flags = 0;
    return Signal(NULL, sessionId, *chatSignalMember, &chatArg, 1, 0, flags);
}


