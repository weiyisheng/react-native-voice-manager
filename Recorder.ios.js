import React from "react";
import { NativeModules, NativeAppEventEmitter } from 'react-native'
const { RNVoiceRecorder } = NativeModules

class VoiceRecorder {

  startRecording(callBack) {

    if(callBack) {
      RNVoiceRecorder.startRecording(true)

      this.VoicePowerListener = NativeAppEventEmitter.addListener(
        'VoicePowerEvent',
        event => {
          callBack({power: {
            average: event.averagePower,
            peak: event.peakPower
          }})
        })
    } else {
      RNVoiceRecorder.startRecording(false)
    }
  }

  stopRecording(callBack) {
    this.VoicePowerListener && this.VoicePowerListener.remove()

    RNVoiceRecorder.stopRecording((error, response) => {
      if(callBack) {
        callBack(error, response)
      }
    })
  }

  getFilePathAndName(uri) {
    if(uri) {
      const filepath = uri.replace('file://', '')
      const split = uri.split('/')
      const filename = split[split.length - 1]
      return {
        filepath,
        filename
      }
    } else {
      return null
    }
  }
}

export default new VoiceRecorder()
