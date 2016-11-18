//
//  FileCheck.m
//  RNVoiceRecorder
//
//  Created by gemini on 11/14/16.
//  Copyright © 2016 gemini. All rights reserved.
//

#import "FileCheck.h"

@implementation FileCheck

+(void) checkSize: (NSString *) filePath
{
    NSLog(@"file filePath : %@", filePath);
    NSFileManager * filemanager = [[NSFileManager alloc]init];
    if([filemanager fileExistsAtPath:filePath isDirectory:NO]){
        NSDictionary * attributes = [filemanager attributesOfItemAtPath:filePath error:nil];
        NSLog(@"file attributes : %@", attributes);
        NSNumber *theFileSize;
        if (theFileSize = [attributes objectForKey:NSFileSize])
            NSLog(@"file size --------------%d", [theFileSize intValue]);
    } else {
        NSLog(@"file not --------------" );
    }
}

@end
