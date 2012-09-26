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

NSString * const kImplementationHeaderXSL = @"objcHeader.xsl";
NSString * const kImplementationSourceXSL = @"objcSource.xsl";
NSString * const kObjectiveCHeaderXSL = @"objcExtensionHeader.xsl";
NSString * const kObjectiveCSourceXSL = @"objcExtensionSource.xsl";

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        NSError *error = nil;
        NSString *xmlFileUrl = [NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding];
        NSString *xslFileUrl = [NSString stringWithCString:argv[2] encoding:NSUTF8StringEncoding];
        NSString *outputFileUrl = [NSString stringWithCString:argv[3] encoding:NSUTF8StringEncoding];
        NSURL *fileUrl = [NSURL fileURLWithPath:xmlFileUrl];
        NSString *outputFileName = [[NSURL fileURLWithPath:outputFileUrl] lastPathComponent];
        NSString *baseFileName = [NSString stringWithCString:argv[10] encoding:NSUTF8StringEncoding];
        
        // prepare to generate the header file
        //
        NSXMLDocument *xmlDocument = [[NSXMLDocument alloc] initWithContentsOfURL:fileUrl options:NSDataReadingMappedIfSafe error:&error];
        if (error) {
            NSLog(@"Error loading XML. %@",error);
            return 1;
        }
        
        NSData *generatedCodeData = [xmlDocument objectByApplyingXSLTAtURL:[NSURL fileURLWithPath:xslFileUrl] arguments:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObject:[NSString stringWithFormat:@"\'%@\'", outputFileName]] forKeys:[NSArray arrayWithObject:@"fileName"]] error:&error];
        if (error) {
            NSLog(@"Error applying XSL. %@",error);
            return 1;
        }
        
        // write the header file to disk
        //
        [generatedCodeData writeToURL:[NSURL fileURLWithPath:outputFileUrl] atomically:YES];
        
        
        // prepare to generate the source file
        //
        xslFileUrl = [NSString stringWithCString:argv[4] encoding:NSUTF8StringEncoding];
        outputFileUrl = [NSString stringWithCString:argv[5] encoding:NSUTF8StringEncoding];
        outputFileName = [[NSURL fileURLWithPath:outputFileUrl] lastPathComponent];
        
        xmlDocument = [[NSXMLDocument alloc] initWithContentsOfURL:fileUrl options:NSDataReadingMappedIfSafe error:&error];
        if (error) {
            NSLog(@"Error loading XML. %@",error);
            return 1;
        }
        
        generatedCodeData = [xmlDocument objectByApplyingXSLTAtURL:[NSURL fileURLWithPath:xslFileUrl] arguments:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSString stringWithFormat:@"\'%@\'",outputFileName], [NSString stringWithFormat:@"\'%@\'",baseFileName],nil] forKeys:[NSArray arrayWithObjects:@"fileName",@"baseFileName",nil]] error:&error];
        if (error) {
            NSLog(@"Error applying XSL. %@",error);
            return 1;
        }
        
        // write the source file to disk
        //
        [generatedCodeData writeToURL:[NSURL fileURLWithPath:outputFileUrl] atomically:YES];
        
        // prepare to generate the category header file
        //
        xslFileUrl = [NSString stringWithCString:argv[6] encoding:NSUTF8StringEncoding];
        outputFileUrl = [NSString stringWithCString:argv[7] encoding:NSUTF8StringEncoding];
        outputFileName = [[NSURL fileURLWithPath:outputFileUrl] lastPathComponent];

        xmlDocument = [[NSXMLDocument alloc] initWithContentsOfURL:fileUrl options:NSDataReadingMappedIfSafe error:&error];
        if (error) {
            NSLog(@"Error loading XML. %@",error);
            return 1;
        }
        
        generatedCodeData = [xmlDocument objectByApplyingXSLTAtURL:[NSURL fileURLWithPath:xslFileUrl] arguments:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSString stringWithFormat:@"\'%@\'",outputFileName], [NSString stringWithFormat:@"\'%@\'",baseFileName],nil] forKeys:[NSArray arrayWithObjects:@"fileName",@"baseFileName",nil]] error:&error];
        if (error) {
            NSLog(@"Error applying XSL. %@",error);
            return 1;
        }
        
        // write the category header file to disk
        //
        [generatedCodeData writeToURL:[NSURL fileURLWithPath:outputFileUrl] atomically:YES];
        
        
        // prepare to generate the category source file
        //
        xslFileUrl = [NSString stringWithCString:argv[8] encoding:NSUTF8StringEncoding];
        outputFileUrl = [NSString stringWithCString:argv[9] encoding:NSUTF8StringEncoding];
        outputFileName = [[NSURL fileURLWithPath:outputFileUrl] lastPathComponent];
        
        xmlDocument = [[NSXMLDocument alloc] initWithContentsOfURL:fileUrl options:NSDataReadingMappedIfSafe error:&error];
        if (error) {
            NSLog(@"Error loading XML. %@",error);
            return 1;
        }
        
        generatedCodeData = [xmlDocument objectByApplyingXSLTAtURL:[NSURL fileURLWithPath:xslFileUrl] arguments:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSString stringWithFormat:@"\'%@\'",outputFileName], [NSString stringWithFormat:@"\'%@\'",baseFileName],nil] forKeys:[NSArray arrayWithObjects:@"fileName",@"baseFileName",nil]] error:&error];
        if (error) {
            NSLog(@"Error applying XSL. %@",error);
            return 1;
        }
        
        // write the category source file to disk
        //
        [generatedCodeData writeToURL:[NSURL fileURLWithPath:outputFileUrl] atomically:YES];
    }
    return 0;
}

