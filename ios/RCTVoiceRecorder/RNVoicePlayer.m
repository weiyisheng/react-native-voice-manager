//
//  RCTVoicePlayer.m
//  RCTVoiceRecorder
//
//  Created by gemini on 11/10/16.
//  Copyright © 2016 gemini. All rights reserved.
//

#import "RNVoicePlayer.h"

@implementation RNVoicePlayer

RCT_EXPORT_MODULE();

-(void) stop
{
    if (audioPlayer != nil) {
        [audioPlayer stop];
        audioPlayer = nil;
    }
}

-(void) setSessions
{
    // Init audio with playback capability
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
}

RCT_EXPORT_METHOD(startPlaying: (NSString *) voicePath)
{
    NSURL *url = [NSURL fileURLWithPath:voicePath];
    NSLog(@"voicePath  : %@", voicePath);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *err = nil;
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&err];
        NSLog(@"audioPlayer  init : %@", url);
        if(err) {
            NSLog(@"audioPlayer init error : %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
            return;
        } else {
            audioPlayer.numberOfLoops = 0;
            [audioPlayer play];
        }
       
    });
}

RCT_EXPORT_METHOD(stopPlaying)
{
    [self stop];
}

@end
