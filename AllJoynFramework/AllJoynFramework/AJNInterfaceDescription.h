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
#import "AJNInterfaceMember.h"
#import "AJNInterfaceProperty.h"
#import "AJNObject.h"

/**
 * Class for describing message bus interfaces. AJNInterfaceDescription objects describe the methods,
 * signals and properties of a AJNBusObject or AJNProxyBusObject.
 *
 * Calling AJNProxyBusObject::addInterface adds the AllJoyn interface described by an
 * AJNInterfaceDescription to a ProxyBusObject instance. After an  AJNInterfaceDescription has been
 * added, the methods described in the interface can be called. Similarly calling
 * AJNBusObject::addInterface adds the interface and its methods, properties, and signal to a
 * BusObject. After an interface has been added method handlers for the methods described in the
 * interface can be added by calling BusObject::AddMethodHandler or BusObject::AddMethodHandlers.
 *
 * An InterfaceDescription can be constructed piecemeal by calling InterfaceDescription::AddMethod,
 * InterfaceDescription::AddMember(), and InterfaceDescription::AddProperty(). Alternatively,
 * calling ProxyBusObject::ParseXml will create the %InterfaceDescription instances for that proxy
 * object directly from an XML string. Calling ProxyBusObject::IntrospectRemoteObject or
 * ProxyBusObject::IntrospectRemoteObjectAsync also creates the %InterfaceDescription
 * instances from XML but in this case the XML is obtained by making a remote Introspect method
 * call on a bus object.
 */
@interface AJNInterfaceDescription : AJNObject

/** Name of interface */
@property (readonly, nonatomic) NSString *name;

/** The members of the interface */
@property (readonly, nonatomic) NSArray *members;

/** The properties of the interface */
@property (readonly, nonatomic) NSArray *properties;

/** An XML description of the interface */
@property (readonly, nonatomic) NSString *xmlDescription;

/**
 * Indicates if this interface is secure. Secure interfaces require end-to-end authentication.
 * The arguments for methods calls made to secure interfaces and signals emitted by secure
 * interfaces are encrypted.
 * @return true if the interface is secure.
 */
@property (readonly, nonatomic) BOOL isSecure;

/**
 * Check for existence of any properties
 *
 * @return  true if interface has any properties.
 */
@property (readonly, nonatomic) BOOL hasProperties;

/**
 * Add a method call member to the interface.
 *
 * @param methodName        Name of method call member.
 * @param inputSignature    Signature of input parameters or NULL for none.
 * @param outputSignature   Signature of output parameters or NULL for none.
 * @param arguments         Comma separated list of input and then output arg names used in annotation XML.
 * @param annotation        Annotation flags.
 * @param accessPermissions Access permission requirements on this call
 *
 * @return  - ER_OK if successful
 *          - ER_BUS_MEMBER_ALREADY_EXISTS if member already exists
 */
- (QStatus)addMethodWithName:(NSString*)methodName inputSignature:(NSString*)inputSignature outputSignature:(NSString*)outputSignature argumentNames:(NSArray*)arguments annotation:(AJNInterfaceAnnotationFlags)annotation accessPermissions:(NSString*)accessPermissions;

/**
 * Add a method call member to the interface.
 *
 * @param methodName        Name of method call member.
 * @param inputSignature    Signature of input parameters or NULL for none.
 * @param outputSignature   Signature of output parameters or NULL for none.
 * @param arguments         Comma separated list of input and then output arg names used in annotation XML.
 * @param annotation        Annotation flags.
 *
 * @return  - ER_OK if successful
 *          - ER_BUS_MEMBER_ALREADY_EXISTS if member already exists
 */
- (QStatus)addMethodWithName:(NSString*)methodName inputSignature:(NSString*)inputSignature outputSignature:(NSString*)outputSignature argumentNames:(NSArray*)arguments annotation:(AJNInterfaceAnnotationFlags)annotation;

/**
 * Add a method call member to the interface.
 *
 * @param methodName        Name of method call member.
 * @param inputSignature    Signature of input parameters or NULL for none.
 * @param outputSignature   Signature of output parameters or NULL for none.
 * @param arguments         Comma separated list of input and then output arg names used in annotation XML.
 *
 * @return  - ER_OK if successful
 *          - ER_BUS_MEMBER_ALREADY_EXISTS if member already exists
 */
- (QStatus)addMethodWithName:(NSString*)methodName inputSignature:(NSString*)inputSignature outputSignature:(NSString*)outputSignature argumentNames:(NSArray*)arguments;

/**
 * Lookup a member method description by name
 *
 * @param methodName  Name of the method to lookup
 * @return  - Pointer to member.
 *          - NULL if does not exist.
 */
- (AJNInterfaceMember*)methodWithName:(NSString*)methodName;

/**
 * Add a signal member to the interface.
 *
 * @param name              Name of method call member.
 * @param inputSignature    Signature of parameters or NULL for none.
 * @param arguments         Comma separated list of arg names used in annotation XML.
 *
 * @return  - ER_OK if successful
 *          - ER_BUS_MEMBER_ALREADY_EXISTS if member already exists
 */
- (QStatus)addSignalWithName:(NSString*)name inputSignature:(NSString*)inputSignature argumentNames:(NSArray*)arguments;

/**
 * Add a signal member to the interface.
 *
 * @param name              Name of method call member.
 * @param inputSignature    Signature of parameters or NULL for none.
 * @param arguments         Comma separated list of arg names used in annotation XML.
 * @param annotation        Annotation flags.
 *
 * @return  - ER_OK if successful
 *          - ER_BUS_MEMBER_ALREADY_EXISTS if member already exists
 */
- (QStatus)addSignalWithName:(NSString*)name inputSignature:(NSString*)inputSignature argumentNames:(NSArray*)arguments annotation:(AJNInterfaceAnnotationFlags)annotation;

/**
 * Add a signal member to the interface.
 *
 * @param name              Name of method call member.
 * @param inputSignature    Signature of parameters or NULL for none.
 * @param arguments         Comma separated list of arg names used in annotation XML.
 * @param annotation        Annotation flags.
 * @param permissions       Access permission requirements on this call
 *
 * @return  - ER_OK if successful
 *          - ER_BUS_MEMBER_ALREADY_EXISTS if member already exists
 */
- (QStatus)addSignalWithName:(NSString*)name inputSignature:(NSString*)inputSignature argumentNames:(NSArray*)arguments annotation:(uint8_t)annotation accessPermissions:(NSString*)permissions;

/**
 * Lookup a member signal description by name
 *
 * @param signalName  Name of the signal to lookup
 * @return  - Pointer to member.
 *          - NULL if does not exist.
 */
- (AJNInterfaceMember*)signalWithName:(NSString*)signalName;

/**
 * Add a property to the interface.
 *
 * @param name          Name of property.
 * @param signature     Property type.
 * @return  - ER_OK if successful.
 *          - ER_BUS_PROPERTY_ALREADY_EXISTS if the property can not be added because it already exists.
 */
- (QStatus)addPropertyWithName:(NSString*)name signature:(NSString*)signature;

/**
 * Add a property to the interface.
 *
 * @param name          Name of property.
 * @param signature     Property type.
 * @param permissions   Access permission - Read Only, Read/Write, or Write Only
 * @return  - ER_OK if successful.
 *          - ER_BUS_PROPERTY_ALREADY_EXISTS if the property can not be added because it already exists.
 */
- (QStatus)addPropertyWithName:(NSString*)name signature:(NSString*)signature accessPermissions:(AJNInterfacePropertyAccessPermissionsFlags)permissions;

/**
 * Check for existence of a property.
 *
 * @param propertyName       Name of the property to lookup
 * @return true if the property exists.
 */
- (AJNInterfaceProperty*)propertyWithName:(NSString*)propertyName;

/**
 * Lookup a member description by name
 *
 * @param name  Name of the member to lookup
 * @return  - Pointer to member.
 *          - NULL if does not exist.
 */
- (AJNInterfaceMember*)memberWithName:(NSString*)name;

/**
 * Check for existence of a member. Optionally check the signature also.
 * @remark
 * if the a signature is not provided this method will only check to see if
 * a member with the given @c name exists.  If a signature is provided a
 * member with the given @c name and @c signature must exist for this to return true.
 *
 * @param name       Name of the member to lookup
 * @param inputs      Input parameter signature of the member to lookup
 * @param outputs     Output parameter signature of the member to lookup (leave NULL for signals)
 * @return true if the member name exists.
 */
- (BOOL)hasMemberWithName:(NSString*)name inputSignature:(NSString*)inputs outputSignature:(NSString*)outputs;

/**
 * Activate this interface. An interface must be activated before it can be used. Activating an
 * interface locks the interface so that is can no longer be modified.
 */
- (void)activate;

@end
