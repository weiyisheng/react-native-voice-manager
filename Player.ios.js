import React from "react";
import { NativeModules } from 'react-native'
const { RNVoicePlayer } = NativeModules

const VoicePlayer = {

  startPlaying(path) {
    RNVoicePlayer.startPlaying(path)
  },

  stopPlaying() {
    RNVoicePlayer.stopPlaying()
  },

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

export default VoicePlayer
