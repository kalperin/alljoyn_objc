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
#import <alljoyn/BusObject.h>
#import "BasicSampleObjectImpl.h"
#import "BasicSampleObject.h"

using namespace ajn;

BasicSampleObjectImpl::BasicSampleObjectImpl(ajn::BusAttachment &bus, const char *path, id<MyMethodSample> aDelegate) :
 AJNBusObjectImpl(bus,path,aDelegate)
{
    /** Add the test interface to this object */
    const InterfaceDescription* basicInterface = bus.GetInterface([kBasicObjectInterfaceName UTF8String]);
    assert(basicInterface);
    AddInterface(*basicInterface);
    
    /** Register the method handlers with the object */
    const MethodEntry methodEntries[] = {
        { basicInterface->GetMember("cat"), static_cast<MessageReceiver::MethodHandler>(&BasicSampleObjectImpl::Concatenate) }
    };
    QStatus status = AddMethodHandlers(methodEntries, sizeof(methodEntries) / sizeof(methodEntries[0]));
    if (ER_OK != status) {
    }    
}

void BasicSampleObjectImpl::Concatenate(const InterfaceDescription::Member *member, Message& msg)
{
    /* Concatenate the two input strings and reply with the result. */
    qcc::String inStr1 = msg->GetArg(0)->v_string.str;
    qcc::String inStr2 = msg->GetArg(1)->v_string.str;

    NSString *returnValue = [(id<MyMethodSample>)delegate concatenateString:[NSString stringWithCString:inStr1.c_str() encoding:NSUTF8StringEncoding] withString:[NSString stringWithCString:inStr2.c_str() encoding:NSUTF8StringEncoding]];    
    MsgArg outArg("s", [returnValue UTF8String]);
    QStatus status = MethodReply(msg, &outArg, 1);
    if (ER_OK != status) {
        // yeah!
    }
    else {
        // oh noes!
    }
}

void BasicSampleObjectImpl::ObjectRegistered()
{
    AJNBusObjectImpl::ObjectRegistered();
}
