////////////////////////////////////////////////////////////////////////////////
// Copyright 2013, Qualcomm Innovation Center, Inc.
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

#import "AJNSignalHandlerImpl.h"

/**
 * Constructor for the AJN session port listener implementation.
 *
 * @param aDelegate         Objective C delegate called when one of the below virtual functions is called.     
 */    
AJNSignalHandlerImpl::AJNSignalHandlerImpl(id<AJNSignalHandler> aDelegate) : m_delegate(aDelegate)
{
    
}

/**
 * Virtual destructor for derivable class.
 */
AJNSignalHandlerImpl::~AJNSignalHandlerImpl()
{
    m_delegate = nil;
}
