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

#import <alljoyn/MsgArg.h>
#import "AJNMessageArgument.h"

using namespace ajn;

@interface AJNObject(Private)

@property (nonatomic) BOOL shouldDeleteHandleOnDealloc;

@end


@interface AJNMessageArgument()

/**
 * Helper to return the C++ API object that is encapsulated by this objective-c class
 */
@property (nonatomic, readonly) MsgArg *msgArg;

@end

@implementation AJNMessageArgument

/**
 * Helper to return the C++ API object that is encapsulated by this objective-c class
 */
- (MsgArg *)msgArg
{
    return (MsgArg*)self.handle;
}

- (AJNType)type
{
    return (AJNType)self.msgArg->typeId;
}

- (NSString *)signature
{
    return [NSString stringWithCString:self.msgArg->Signature().c_str() encoding:NSUTF8StringEncoding];
}

- (NSString *)xml
{
    return [NSString stringWithCString:self.msgArg->ToString().c_str() encoding:NSUTF8StringEncoding];
}

- (NSString *)signatureFromMessageArguments:(NSArray *)arguments
{
    NSString *result = nil;
    if (arguments.count) {
        MsgArg * pArgs = new MsgArg[arguments.count];
        for (int i = 0; i < arguments.count; i++) {
            pArgs[i] = *[[arguments objectAtIndex:i] msgArg];
        }
        result = [NSString stringWithCString:self.msgArg->Signature(pArgs, arguments.count).c_str() encoding:NSUTF8StringEncoding];
        delete [] pArgs;
    }
    return result;
}

- (NSString *)xmlFromMessageArguments:(NSArray*)arguments
{
    NSString *result = nil;
    if (arguments.count) {
        MsgArg * pArgs = new MsgArg[arguments.count];
        for (int i = 0; i < arguments.count; i++) {
            pArgs[i] = *[[arguments objectAtIndex:i] msgArg];
        }
        result = [NSString stringWithCString:self.msgArg->ToString(pArgs, arguments.count).c_str() encoding:NSUTF8StringEncoding];
        delete [] pArgs;
    }
    return result;
}

- (BOOL)conformsToSignature:(NSString *)signature
{
    return self.msgArg->HasSignature([signature UTF8String]);
}

- (QStatus)setValue:(NSString *)signature, ...
{
    va_list args;
    va_start(args, signature);
    QStatus status = self.msgArg->Set([signature UTF8String], args);
    va_end(args);
    return status;
}

- (QStatus)value:(NSString *)signature, ...
{
    va_list args;
    va_start(args, signature);
    QStatus status = self.msgArg->Get([signature UTF8String], args);
    va_end(args);
    return status;
}

- (void)dealloc
{
    if (self.shouldDeleteHandleOnDealloc) {
        MsgArg *pArg = static_cast<MsgArg*>(self.handle);
        delete pArg;
        self.handle = nil;
    }
}

@end
