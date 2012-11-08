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
//  AJNSecureObject.mm
//
////////////////////////////////////////////////////////////////////////////////

#import <alljoyn/BusAttachment.h>
#import <alljoyn/BusObject.h>
#import "AJNBusObjectImpl.h"
#import "AJNInterfaceDescription.h"
#import "AJNMessageArgument.h"
#import "AJNSignalHandlerImpl.h"

#import "SecureObject.h"

using namespace ajn;

////////////////////////////////////////////////////////////////////////////////
//
//  C++ Bus Object class declaration for SecureObjectImpl
//
////////////////////////////////////////////////////////////////////////////////
class SecureObjectImpl : public AJNBusObjectImpl
{
private:
    
    
public:
    SecureObjectImpl(BusAttachment &bus, const char *path, id<SecureObjectDelegate> aDelegate);

    
    
    // methods
    //
    void Ping(const InterfaceDescription::Member* member, Message& msg);

    
    // signals
    //
    
};
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
//  C++ Bus Object implementation for SecureObjectImpl
//
////////////////////////////////////////////////////////////////////////////////

SecureObjectImpl::SecureObjectImpl(BusAttachment &bus, const char *path, id<SecureObjectDelegate> aDelegate) : 
    AJNBusObjectImpl(bus,path,aDelegate)
{
    const InterfaceDescription* interfaceDescription = NULL;
    QStatus status;
    status = ER_OK;
    
    
    // Add the org.alljoyn.bus.samples.secure.SecureInterface interface to this object
    //
    interfaceDescription = bus.GetInterface("org.alljoyn.bus.samples.secure.SecureInterface");
    assert(interfaceDescription);
    AddInterface(*interfaceDescription);

    
    // Register the method handlers for interface SecureObjectDelegate with the object
    //
    const MethodEntry methodEntriesForSecureObjectDelegate[] = {

        {
			interfaceDescription->GetMember("Ping"), static_cast<MessageReceiver::MethodHandler>(&SecureObjectImpl::Ping)
		}
    
    };
    
    status = AddMethodHandlers(methodEntriesForSecureObjectDelegate, sizeof(methodEntriesForSecureObjectDelegate) / sizeof(methodEntriesForSecureObjectDelegate[0]));
    if (ER_OK != status) {
        NSLog(@"ERROR: An error occurred while adding method handlers for interface org.alljoyn.bus.samples.secure.SecureInterface to the interface description. %@", [AJNStatus descriptionForStatusCode:status]);
    }
    

}


void SecureObjectImpl::Ping(const InterfaceDescription::Member *member, Message& msg)
{
    @autoreleasepool {
    
    
    
    
    // get all input arguments
    //
    
    qcc::String inArg0 = msg->GetArg(0)->v_string.str;
        
    // declare the output arguments
    //
    
	NSString* outArg0;

    
    // call the Objective-C delegate method
    //
    
	outArg0 = [(id<SecureObjectDelegate>)delegate sendPingString:[NSString stringWithCString:inArg0.c_str() encoding:NSUTF8StringEncoding]];
            
        
    // formulate the reply
    //
    MsgArg outArgs[1];
    
    outArgs[0].Set("s", [outArg0 UTF8String]);

    QStatus status = MethodReply(msg, outArgs, 1);
    if (ER_OK != status) {
        NSLog(@"ERROR: An error occurred when attempting to send a method reply for Ping. %@", [AJNStatus descriptionForStatusCode:status]);
    }        
    
    
    }
}



////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
//  Objective-C Bus Object implementation for AJNSecureObject
//
////////////////////////////////////////////////////////////////////////////////

@implementation AJNSecureObject

@dynamic handle;



- (SecureObjectImpl*)busObject
{
    return static_cast<SecureObjectImpl*>(self.handle);
}

- (id)initWithBusAttachment:(AJNBusAttachment *)busAttachment onPath:(NSString *)path
{
    self = [super initWithBusAttachment:busAttachment onPath:path];
    if (self) {
        QStatus status;

        status = ER_OK;
        
        AJNInterfaceDescription *interfaceDescription;
        
    
        //
        // SecureObjectDelegate interface (org.alljoyn.bus.samples.secure.SecureInterface)
        //
        // create an interface description, or if that fails, get the interface as it was already created
        //
        interfaceDescription = [busAttachment createInterfaceWithName:@"org.alljoyn.bus.samples.secure.SecureInterface"];
        
    
        // add the methods to the interface description
        //
    
        status = [interfaceDescription addMethodWithName:@"Ping" inputSignature:@"s" outputSignature:@"s" argumentNames:[NSArray arrayWithObjects:@"inStr",@"outStr", nil]];
        
        if (status != ER_OK && status != ER_BUS_MEMBER_ALREADY_EXISTS) {
            @throw [NSException exceptionWithName:@"BusObjectInitFailed" reason:@"Unable to add method to interface: Ping" userInfo:nil];
        }

    
        [interfaceDescription activate];


        // create the internal C++ bus object
        //
        SecureObjectImpl *busObject = new SecureObjectImpl(*((ajn::BusAttachment*)busAttachment.handle), [path UTF8String], (id<SecureObjectDelegate>)self);
        
        self.handle = busObject;
    }
    return self;
}

- (void)dealloc
{
    SecureObjectImpl *busObject = [self busObject];
    delete busObject;
    self.handle = nil;
}

    
- (NSString*)sendPingString:(NSString*)inStr
{
    //
    // GENERATED CODE - DO NOT EDIT
    //
    // Create a category or subclass in separate .h/.m files
    @throw([NSException exceptionWithName:@"NotImplementedException" reason:@"You must override this method in a subclass" userInfo:nil]);
}

    
@end

////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
//  Objective-C Proxy Bus Object implementation for SecureObject
//
////////////////////////////////////////////////////////////////////////////////

@interface SecureObjectProxy(Private)

@property (nonatomic, strong) AJNBusAttachment *bus;

- (ProxyBusObject*)proxyBusObject;

@end

@implementation SecureObjectProxy
    
- (NSString*)sendPingString:(NSString*)inStr
{
    [self addInterfaceNamed:@"org.alljoyn.bus.samples.secure.SecureInterface"];
    
    // prepare the input arguments
    //
    
    Message reply(*((BusAttachment*)self.bus.handle));    
    MsgArg inArgs[1];
    
    inArgs[0].Set("s", [inStr UTF8String]);


    // make the function call using the C++ proxy object
    //
    
    QStatus status = self.proxyBusObject->MethodCall("org.alljoyn.bus.samples.secure.SecureInterface", "Ping", inArgs, 1, reply, 5000);
    if (ER_OK != status) {
        NSLog(@"ERROR: ProxyBusObject::MethodCall on org.alljoyn.bus.samples.secure.SecureInterface failed. %@", [AJNStatus descriptionForStatusCode:status]);
        
        return nil;
            
    }

    
    // pass the output arguments back to the caller
    //
    
        
    return [NSString stringWithCString:reply->GetArg()->v_string.str encoding:NSUTF8StringEncoding];
        

}

@end

////////////////////////////////////////////////////////////////////////////////
