//
//  RCTVoiceRecorder.m
//  RCTVoiceRecorder
//
//  Created by gemini on 11/9/16.
//  Copyright © 2016 gemini. All rights reserved.
//  http://stackoverflow.com/questions/1010343/how-do-i-record-audio-on-iphone-with-avaudiorecorder
//  thanks to : Shaybc
//

#import "RCTVoiceRecorder.h"

@implementation RCTVoiceRecorder

RCT_EXPORT_MODULE();

-(RCTVoiceRecorder *) init
{
    self = [super init];
    recordEncoding = ENC_AAC;
    return self;
}

-(void) stop {
    if (audioRecorder != nil) {
        [audioRecorder stop];
        audioRecorder = nil;
    }
}

RCT_EXPORT_METHOD(startRecording)
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
    
    NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] initWithCapacity:10];
    if(recordEncoding == ENC_PCM)
    {
        [recordSettings setObject:[NSNumber numberWithInt: kAudioFormatLinearPCM] forKey: AVFormatIDKey];
        [recordSettings setObject:[NSNumber numberWithFloat:44100.0] forKey: AVSampleRateKey];
        [recordSettings setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
        [recordSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        [recordSettings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
        [recordSettings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    } else {
        NSNumber *formatObject;
        
        switch (recordEncoding) {
            case (ENC_AAC):
                formatObject = [NSNumber numberWithInt: kAudioFormatMPEG4AAC];
                break;
            case (ENC_ALAC):
                formatObject = [NSNumber numberWithInt: kAudioFormatAppleLossless];
                break;
            case (ENC_IMA4):
                formatObject = [NSNumber numberWithInt: kAudioFormatAppleIMA4];
                break;
            case (ENC_ILBC):
                formatObject = [NSNumber numberWithInt: kAudioFormatiLBC];
                break;
            case (ENC_ULAW):
                formatObject = [NSNumber numberWithInt: kAudioFormatULaw];
                break;
            default:
                formatObject = [NSNumber numberWithInt: kAudioFormatAppleIMA4];
        }
        
        [recordSettings setObject:formatObject forKey: AVFormatIDKey];
        [recordSettings setObject:[NSNumber numberWithFloat:44100.0] forKey: AVSampleRateKey];
        [recordSettings setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
        [recordSettings setObject:[NSNumber numberWithInt:12800] forKey:AVEncoderBitRateKey];
        [recordSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        [recordSettings setObject:[NSNumber numberWithInt: AVAudioQualityHigh] forKey: AVEncoderAudioQualityKey];
    }
    
//    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/recordTest.caf", [[NSBundle mainBundle] resourcePath]]];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = paths[0];
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/voice.caf", basePath]];
    
    NSError *error = nil;
    audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSettings error:&error];
    
    if ([audioRecorder prepareToRecord] == YES){
        [audioRecorder record];
        audioPath = [url absoluteString];
    } else {
//        int errorCode = CFSwapInt32HostToBig ([error code]);
//        NSLog(@"Error: %@ [%4.4s])" , [error localizedDescription], (char*)&errorCode);
    }

}

RCT_EXPORT_METHOD(stopRecording: (RCTResponseSenderBlock) callback)
{
    [self stop];
    if(audioPath != nil) {
        NSArray *events = [NSArray arrayWithObjects: audioPath, nil];
        callback(@[[NSNull null], events]);
    } else {
        NSArray *errors = [NSArray arrayWithObjects: @"failed: the voice path is null !", nil];
        callback(@[errors, [NSNull null]]);
    }
}

@end
