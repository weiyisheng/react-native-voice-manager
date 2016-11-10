//
//  RCTVoiceRecorder.h
//  RCTVoiceRecorder
//
//  Created by gemini on 11/9/16.
//  Copyright © 2016 gemini. All rights reserved.
//  http://stackoverflow.com/questions/1010343/how-do-i-record-audio-on-iphone-with-avaudiorecorder
//

#import <Foundation/Foundation.h>

#import "RCTBridgeModule.h"

#import <AVFoundation/AVFoundation.h>

@interface RCTVoiceRecorder : NSObject <RCTBridgeModule>
{
    AVAudioPlayer *audioPlayer;
    AVAudioRecorder *audioRecorder;
    int recordEncoding;
    NSString *audioPath;
    enum
    {
        ENC_AAC = 1,
        ENC_ALAC = 2,
        ENC_IMA4 = 3,
        ENC_ILBC = 4,
        ENC_ULAW = 5,
        ENC_PCM = 6,
    } encodingTypes;
}

-(IBAction) startRecording;
-(IBAction) stopRecording;
-(IBAction) playRecording;
-(IBAction) stopPlaying;

@end
