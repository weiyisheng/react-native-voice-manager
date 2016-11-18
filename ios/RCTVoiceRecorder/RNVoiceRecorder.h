//
//  RCTVoiceRecorder.h
//  RCTVoiceRecorder
//
//  Created by gemini on 11/9/16.
//

#import <Foundation/Foundation.h>

#import "RCTBridgeModule.h"

#import <AVFoundation/AVFoundation.h>

#import "FileCheck.h"

@interface RNVoiceRecorder : NSObject <RCTBridgeModule>
{
    AVAudioRecorder *audioRecorder;
    int recordEncoding;
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

@property (nonatomic, strong) dispatch_source_t powerLevelTimer;

@end
