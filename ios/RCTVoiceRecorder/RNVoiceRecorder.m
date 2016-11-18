//
//  RCTVoiceRecorder.m
//  RCTVoiceRecorder
//
//  Created by gemini on 11/9/16.
//  Copyright © 2016 gemini. All rights reserved.
//

#import "RNVoiceRecorder.h"

#import "RCTEventDispatcher.h"

@implementation RNVoiceRecorder

@synthesize bridge = _bridge;

RCT_EXPORT_MODULE();

-(RNVoiceRecorder *) init
{
    self = [super init];
    recordEncoding = ENC_AAC;
    return self;
}

-(NSURL *) stop
{
    if (audioRecorder != nil) {
        NSURL *url = [audioRecorder url];
        [audioRecorder stop];
        audioRecorder = nil;
        return url;
    } else {
        return nil;
    }
}

-(void) setSession
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *error = nil;
    [audioSession setCategory:AVAudioSessionCategoryRecord error:&error];
    if(error){
        NSLog(@"audioSession setCategory : %@ %ld %@", [error domain], (long)[error code], [[error userInfo] description]);
        return;
    }
    error = nil;
    [audioSession setActive:YES error:&error];
    if(error){
        NSLog(@"audioSession setActive : %@ %ld %@", [error domain], (long)[error code], [[error userInfo] description]);
        return;
    }
}

-(NSMutableDictionary *)getSettings
{
    NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] initWithCapacity:10];
    //    if(recordEncoding == ENC_PCM)
    //    {
    //        [recordSettings setObject:[NSNumber numberWithInt: kAudioFormatLinearPCM] forKey: AVFormatIDKey];
    //        [recordSettings setObject:[NSNumber numberWithFloat:44100.0] forKey: AVSampleRateKey];
    //        [recordSettings setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    //        [recordSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    //        [recordSettings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
    //        [recordSettings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    //    } else {
    //        NSNumber *formatObject;
    //
    //        switch (recordEncoding) {
    //            case (ENC_AAC):
    //                formatObject = [NSNumber numberWithInt: kAudioFormatMPEG4AAC];
    //                break;
    //            case (ENC_ALAC):
    //                formatObject = [NSNumber numberWithInt: kAudioFormatAppleLossless];
    //                break;
    //            case (ENC_IMA4):
    //                formatObject = [NSNumber numberWithInt: kAudioFormatAppleIMA4];
    //                break;
    //            case (ENC_ILBC):
    //                formatObject = [NSNumber numberWithInt: kAudioFormatiLBC];
    //                break;
    //            case (ENC_ULAW):
    //                formatObject = [NSNumber numberWithInt: kAudioFormatULaw];
    //                break;
    //            default:
    //                formatObject = [NSNumber numberWithInt: kAudioFormatAppleIMA4];
    //        }
    //
    //        [recordSettings setObject:formatObject forKey: AVFormatIDKey];
    //        [recordSettings setObject:[NSNumber numberWithFloat:44100.0] forKey: AVSampleRateKey];
    //        [recordSettings setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    //        [recordSettings setObject:[NSNumber numberWithInt:12800] forKey:AVEncoderBitRateKey];
    //        [recordSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    //        [recordSettings setObject:[NSNumber numberWithInt: AVAudioQualityHigh] forKey: AVEncoderAudioQualityKey];
    //    }
    
    [recordSettings setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    [recordSettings setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSettings setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    [recordSettings setValue :[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    [recordSettings setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
    [recordSettings setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    
    return recordSettings;
}

-(NSURL *) setVoiceUrl
{
    
    NSDate *now = [NSDate dateWithTimeIntervalSinceNow:0];
    NSString *caldate = [now description];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = paths[0];
    NSString *recorderFilePath = [NSString stringWithFormat:@"%@/%@.caf", basePath, caldate];
    
    NSURL *url = [NSURL fileURLWithPath:recorderFilePath];
    return url;
}

- (void)stopLevelTimer {
    if(self.powerLevelTimer != nil) {
        dispatch_cancel(self.powerLevelTimer);
    }
}

- (void)startLevelTimer {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.powerLevelTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.powerLevelTimer, dispatch_walltime(NULL, 0), 0.1 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.powerLevelTimer, ^{
        if(audioRecorder != nil) {
            [audioRecorder updateMeters];
            //NSLog(@"Peak Power : %f , %f", [audioRecorder peakPowerForChannel:0], [audioRecorder averagePowerForChannel:0]);
            NSArray *events = [NSArray arrayWithObjects: [NSNumber numberWithFloat:[audioRecorder peakPowerForChannel:0]], nil];
            [self.bridge.eventDispatcher sendAppEventWithName:@"VoicePowerEvent"
                                                         body:@{@"peakPower": [NSNumber numberWithFloat:[audioRecorder peakPowerForChannel:0]],
                                                                @"averagePower": [NSNumber numberWithFloat:[audioRecorder averagePowerForChannel:0]]
                                                                }];
        }
    });
    dispatch_resume(self.powerLevelTimer);
}

RCT_EXPORT_METHOD(startRecording: (BOOL) shouldSetPowerListner)
{
    [self setSession];
    
    NSURL *url = [self setVoiceUrl];
    
    NSMutableDictionary *recordSettings = [self getSettings];
    
    NSError *error = nil;
    
    audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSettings error:&error];
    
    if ([audioRecorder prepareToRecord] == YES){
        audioRecorder.meteringEnabled = YES;
        [audioRecorder record];
        if(shouldSetPowerListner) {
            [self startLevelTimer];
        }
    } else {
        NSLog(@"audioRecorder prepareToRecord : %@ %ld %@ %d", [error domain], (long)[error code], [[error userInfo]description], [audioRecorder prepareToRecord]);
        return;
    }
}

RCT_EXPORT_METHOD(stopRecording: (RCTResponseSenderBlock) callback)
{
    
    NSURL * url = [self stop];
    [self stopLevelTimer];
    if(url != nil) {
        NSArray *events = [NSArray arrayWithObjects: [url path], nil];
        callback(@[[NSNull null], events]);
    } else {
        NSArray *errors = [NSArray arrayWithObjects: @"failed: the voice path is null !", nil];
        callback(@[errors, [NSNull null]]);
    }
}

@end
