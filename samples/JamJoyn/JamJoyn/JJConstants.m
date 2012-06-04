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

#import "JJConstants.h"

const AJNSessionPort kServicePort = 101;
NSString * const kServicePath = @"/commandPasserService";
NSString * const kServiceName = @"org.alljoyn.bus.samples.commandpasser";
NSString * const kInterfaceName = @"org.alljoyn.bus.samples.commandpasser";
NSString * const kAppName = @"JamJoyn Player";
NSString * const kXMLInterfaceDescription = @"<node name=\"/commandPasserService\">\n\
    <interface name=\"org.alljoyn.bus.samples.commandpasser\">\n\
        <method name=\"Command\">\n\
            <arg name=\"command\" type=\"s\" direction=\"in\"/>\n\
            <arg name=\"arg\" type=\"s\" direction=\"in\"/>\n\
        </method>\n\
        <signal name=\"CommandSignal\">\n\
            <arg name=\"command\" type=\"s\"/>\n\
            <arg name=\"arg\" type=\"s\"/>\n\
        </signal>\n\
        <method name=\"SetByteData\">\n\
            <arg name=\"filename\" type=\"s\" direction=\"in\"/>\n\
            <arg name=\"title\" type=\"s\" direction=\"in\"/>\n\
            <arg name=\"album\" type=\"s\" direction=\"in\"/>\n\
            <arg name=\"artist\" type=\"s\" direction=\"in\"/>\n\
            <arg name=\"numChunks\" type=\"i\" direction=\"in\"/>\n\
            <arg name=\"chunkIndex\" type=\"i\" direction=\"in\"/>\n\
            <arg name=\"bytes\" type=\"ab\" direction=\"in\"/>\n\
        </method>\n\
        <signal name=\"Announce\">\n\
            <arg name=\"nickName\" type=\"s\"/>\n\
            <arg name=\"isHost\" type=\"b\"/>\n\
        </signal>\n\
        <method name=\"sendMySongs\">\n\
            <arg name=\"songs\" type=\"a(sssssiiss)\" direction=\"in\"/>\n\
        </method>\n\
        <signal name=\"SetPlaylistSongs\">\n\
            <arg name=\"songs\" type=\"a(sssssiiss)\"/>\n\
        </signal>\n\
        <method name=\"sendSongInfo\">\n\
            <arg name=\"song\" type=\"(sssssiiss)\" direction=\"in\"/>\n\
        </method>\n\
    </interface>\n\
</node>\n";
NSString * const kMediaBaseName = @"org.alljoyn.Media.Server";
