//
//  RCTVoicePlayer.h
//  RCTVoiceRecorder
//
//  Created by gemini on 11/10/16.
//  Copyright © 2016 gemini. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RCTBridgeModule.h"

#import <AVFoundation/AVFoundation.h>

@interface RNVoicePlayer : NSObject <RCTBridgeModule>
{
    AVAudioPlayer *audioPlayer;
}

@end
