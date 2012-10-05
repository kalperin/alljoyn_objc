AllJoyn iOS and OS/X SDK README

************************************************************************************

PLEASE READ THIS DOCUMENT INCLUDED WITH THE SDK:

AllJoyn Programming Guide for the Objective-C Language

************************************************************************************

Minimum Requirements for AllJoyn Development System

1. OS/X 10.7 (Lion) or higher
2. Xcode 4.5 or higher

Prerequisites

1. Xcode is available for free from the Mac App Store at the following web address:
   http://itunes.apple.com/us/app/xcode/id497799835?mt=12
2. OpenSSL is required for iOS development and is available at the following web
   address: http://www.openssl.org/
   AllJoyn has been tested with version 1.01 of OpenSSL.
3. Download the Xcode project that can be used to build OpenSSL for iOS from GitHub,
   at the following web address: https://github.com/sqlcipher/openssl-xcode/ 

Installation

1. Unzip the SDK package to a folder on your development system.
2. Copy the OpenSSL source into the following folder in your AllJoyn SDK root
   folder: <ALLJOYN_SDK_ROOT>/common/crypto/openssl/openssl-1.01/
3. Navigate to the above folder in Finder and copy the openssl.xcodeproj folder you
   downloaded from GitHub into this folder.
4. Build the libssl and libcrypto libraries one at a time for each combination of
   configuration (debug|release) and platform (iphoneos|iphonesimulator) that you
   need for your iOS project. For each platform/configuration combination, copy the
   resultant libssl.a and libcrypto.a files to the following folder structure:
  <ALLJOYN_SDK_ROOT>/common/crypto/openssl/openssl-1.01/build/[Debug | Release]-[iphoneos | iphonesimulator]/

Tour

The SDK contains an alljoyn_core folder and an alljoyn_objc folder. 

Samples for iOS and OS/X. The samples are located under alljoyn_objc/samples. 

Code Generator. A code generator is included to assist your development of
AllJoyn-enabled apps for iOS and Mac OS/X. The source for this tool is located
under alljoyn_objc/AllJoynCodeGenerator.

Please take the time to read the “AllJoyn Programming Guide for the Objective-C
Language” document and follow the tutorial contained within, as it explains in easy
to follow steps how to create a new AllJoyn-enabled iOS app from scratch, in
addition to introducing you to some background concepts that will help you
understand AllJoyn.


