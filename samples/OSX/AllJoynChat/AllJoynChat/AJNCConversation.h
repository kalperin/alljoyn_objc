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
#import "AJNCBusObject.h"
#import "AJNSessionOptions.h"
#import "AJNBusAttachment.h"

typedef enum {
    kAJNCConversationTypeRemoteHost = 0,
    kAJNCConversationTypeLocalHost = 1
} AJNCConversationType;

@interface AJNCConversation : NSObject<AJNChatReceiver>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, readonly) NSString *displayName;
@property (nonatomic) AJNSessionId identifier;
@property (nonatomic, strong) AJNCBusObject *chatObject;
@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic) AJNCConversationType type;
@property (nonatomic) NSInteger totalParticipants;

- (id)initWithName:(NSString *)name identifier:(AJNSessionId)sessionId busObject:(AJNCBusObject *)chatObject;

@end
