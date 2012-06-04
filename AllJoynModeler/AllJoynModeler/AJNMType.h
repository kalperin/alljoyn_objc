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

typedef enum {
    kAJNMDBusTypeByte       = 'y',
    kAJNMDBusTypeBoolean    = 'b',
    kAJNMDBusTypeInt16      = 'n',
    kAJNMDBusTypeUInt16     = 'q',
    kAJNMDBusTypeInt32      = 'i',
    kAJNMDBusTypeUInt32     = 'u',
    kAJNMDBusTypeInt64      = 'x',
    kAJNMDBusTypeUInt64     = 't',
    kAJNMDBusTypeDouble     = 'd',
    kAJNMDBusTypeString     = 's',
    kAJNMDBusTypeObjectPath = 'o',
    kAJNMDBusTypeSignature  = 'g',
    kAJNMDBusTypeArray      = 'a'
} AJNMDBusType;

@interface AJNMType : NSObject

@property (nonatomic) AJNMDBusType typeId;
@property (nonatomic, readonly) NSString *signature;

+ (AJNMType *)typeFromSignature:(NSString *)signature;

@end
