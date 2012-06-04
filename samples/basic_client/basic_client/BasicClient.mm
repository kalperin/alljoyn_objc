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

#import "BasicClient.h"

#include <qcc/platform.h>

#include <assert.h>
#include <signal.h>
#include <stdio.h>
#include <vector>

#include <qcc/String.h>

#include <alljoyn/BusAttachment.h>
#include <alljoyn/version.h>
#include <alljoyn/AllJoynStd.h>
#include <Status.h>

using namespace std;
using namespace qcc;
using namespace ajn;

static BasicClient *s_basicClient;

/** Static top level message bus object */
static BusAttachment* g_msgBus = NULL;

/*constants*/
static const char* INTERFACE_NAME = "org.alljoyn.Bus.method_sample";
static const char* SERVICE_NAME = "org.alljoyn.Bus.method_sample";
static const char* SERVICE_PATH = "/method_sample";
static const SessionPort SERVICE_PORT = 25;

static bool s_joinComplete = false;
static SessionId s_sessionId = 0;

static volatile sig_atomic_t g_interrupt = false;

static void SigIntHandler(int sig)
{
    g_interrupt = true;
}

/** AllJoynListener receives discovery events from AllJoyn */
class MyBusListener : public BusListener, public SessionListener {
public:
void FoundAdvertisedName(const char* name, TransportMask transport, const char* namePrefix)
{
    [s_basicClient.delegate didReceiveStatusUpdateMessage:[NSString stringWithFormat:@"FoundAdvertisedName(name=%s, prefix=%s)\n", name, namePrefix]];
    if (0 == strcmp(name, SERVICE_NAME) && g_msgBus) {
        /* We found a remote bus that is advertising basic sercice's  well-known name so connect to it */
        SessionOpts opts(SessionOpts::TRAFFIC_MESSAGES, false, SessionOpts::PROXIMITY_ANY, TRANSPORT_ANY);
        QStatus status = g_msgBus->JoinSession(name, SERVICE_PORT, this, s_sessionId, opts);
        if (ER_OK != status) {
            [s_basicClient.delegate didReceiveStatusUpdateMessage:[NSString stringWithFormat:@"JoinSession failed (status=%s)\n", QCC_StatusText(status)]];
        } else {
            [s_basicClient.delegate didReceiveStatusUpdateMessage:[NSString stringWithFormat:@"JoinSession SUCCESS (Session id=%d)\n", s_sessionId]];
        }
    }
    if (!g_msgBus) {
        [s_basicClient.delegate didReceiveStatusUpdateMessage:@"Message bus attachment not allocated\n"];
    }
    s_joinComplete = true;
}

void NameOwnerChanged(const char* busName, const char* previousOwner, const char* newOwner)
{
    if (newOwner && (0 == strcmp(busName, SERVICE_NAME))) {
        [s_basicClient.delegate didReceiveStatusUpdateMessage:[NSString stringWithFormat:@"NameOwnerChanged: name=%s, oldOwner=%s, newOwner=%s\n",
               busName,
               previousOwner ? previousOwner : "<none>",
               newOwner ? newOwner : "<none>"]];
    }
}
};

/** Static bus listener */
static MyBusListener g_busListener;


/** Main entry point */
int clientMain()
{
    QStatus status = ER_OK;
    
    s_joinComplete = false;
    
    [s_basicClient.delegate didReceiveStatusUpdateMessage:[NSString stringWithFormat:@"AllJoyn Library version: %s\n", ajn::GetVersion()]];
    [s_basicClient.delegate didReceiveStatusUpdateMessage:[NSString stringWithFormat:@"AllJoyn Library build info: %s\n", ajn::GetBuildInfo()]];
    
    /* Install SIGINT handler */
    signal(SIGINT, SigIntHandler);
    
    const char* connectArgs = getenv("BUS_ADDRESS");
    if (connectArgs == NULL) {
#ifdef _WIN32
        connectArgs = "tcp:addr=127.0.0.1,port=9955";
#else
        connectArgs = "unix:abstract=alljoyn";
#endif
    }
    
    /* Create message bus */
    g_msgBus = new BusAttachment("myApp", true);
    
    /* Add org.alljoyn.Bus.method_sample interface */
    InterfaceDescription* testIntf = NULL;
    status = g_msgBus->CreateInterface(INTERFACE_NAME, testIntf);
    if (status == ER_OK) {
        [s_basicClient.delegate didReceiveStatusUpdateMessage:@"Interface Created.\n"];
        testIntf->AddMethod("cat", "ss",  "s", "inStr1,inStr2,outStr", 0);
        testIntf->Activate();
    } else {
        [s_basicClient.delegate didReceiveStatusUpdateMessage:@"Failed to create interface 'org.alljoyn.Bus.method_sample'\n"];
    }
    
    
    /* Start the msg bus */
    if (ER_OK == status) {
        status = g_msgBus->Start();
        if (ER_OK != status) {
            [s_basicClient.delegate didReceiveStatusUpdateMessage:@"BusAttachment::Start failed\n"];
        } else {
            [s_basicClient.delegate didReceiveStatusUpdateMessage:@"BusAttachment started.\n"];
        }
    }
    
    /* Connect to the bus */
    if (ER_OK == status) {
        status = g_msgBus->Connect(connectArgs);
        if (ER_OK != status) {
            [s_basicClient.delegate didReceiveStatusUpdateMessage:[NSString stringWithFormat:@"BusAttachment::Connect(\"%s\") failed\n", connectArgs]];
        } else {
            [s_basicClient.delegate didReceiveStatusUpdateMessage:[NSString stringWithFormat:@"BusAttchement connected to %s\n", connectArgs]];
        }
    }
    
    /* Register a bus listener in order to get discovery indications */
    if (ER_OK == status) {
        g_msgBus->RegisterBusListener(g_busListener);
        [s_basicClient.delegate didReceiveStatusUpdateMessage:@"BusListener Registered.\n"];
    }
    
    /* Begin discovery on the well-known name of the service to be called */
    if (ER_OK == status) {
        status = g_msgBus->FindAdvertisedName(SERVICE_NAME);
        if (status != ER_OK) {
            [s_basicClient.delegate didReceiveStatusUpdateMessage:[NSString stringWithFormat:@"org.alljoyn.Bus.FindAdvertisedName failed (%s))\n", QCC_StatusText(status)]];
        }
    }
    
    /* Wait for join session to complete */
    while (!s_joinComplete && !g_interrupt) {
#ifdef _WIN32
        Sleep(100);
#else
        usleep(100 * 1000);
#endif
    }
    
    if (status == ER_OK && g_interrupt == false) {
        ProxyBusObject remoteObj(*g_msgBus, SERVICE_NAME, SERVICE_PATH, s_sessionId);
        const InterfaceDescription* alljoynTestIntf = g_msgBus->GetInterface(INTERFACE_NAME);
        assert(alljoynTestIntf);
        remoteObj.AddInterface(*alljoynTestIntf);
        
        Message reply(*g_msgBus);
        MsgArg inputs[2];
        inputs[0].Set("s", "Hello ");
        inputs[1].Set("s", "World!");
        status = remoteObj.MethodCall(SERVICE_NAME, "cat", inputs, 2, reply, 5000);
        if (ER_OK == status) {
            [s_basicClient.delegate didReceiveStatusUpdateMessage:[NSString stringWithFormat:@"%s.%s ( path=%s) returned \"%s\"\n", SERVICE_NAME, "cat",
                   SERVICE_PATH, reply->GetArg(0)->v_string.str]];
        } else {
            [s_basicClient.delegate didReceiveStatusUpdateMessage:[NSString stringWithFormat:@"MethodCall on %s.%s failed\n", SERVICE_NAME, "cat"]];
        }
    }
    
    /* Deallocate bus */
    if (g_msgBus) {
        g_msgBus->UnregisterBusListener(g_busListener);
        g_msgBus->Disconnect(connectArgs);
        g_msgBus->Stop();

        BusAttachment* deleteMe = g_msgBus;
        g_msgBus = NULL;
        delete deleteMe;
    }
    
    [s_basicClient.delegate didReceiveStatusUpdateMessage:[NSString stringWithFormat:@"basic client completed with status %d (%s)\n", status, QCC_StatusText(status)]];
    
    return (int) status;
}


@implementation BasicClient

@synthesize delegate;

+ (BasicClient*)sharedInstance
{
    @synchronized(self) {
        if (s_basicClient == nil) {
            s_basicClient = [[BasicClient alloc] init];
        }
    }
    return s_basicClient;
}

- (void)sendHelloMessage
{
    dispatch_queue_t clientQueue = dispatch_queue_create("org.alljoyn.basic-service.clientQueue",NULL);
    dispatch_async( clientQueue, ^{
        @synchronized(self) {
            clientMain();
        }
    });
    dispatch_release(clientQueue);
}

@end
