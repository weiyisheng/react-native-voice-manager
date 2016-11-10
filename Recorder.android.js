import React from "react";
import { DeviceEventEmitter, NativeModules } from 'react-native'
const CustomRecord = NativeModules.AudioRecorder

class AudioRecorder {

  constructor() {

  }

  startRecord() {
    CustomRecord.startRecord()
  }

  stopRecord(callBack) {
    CustomRecord.stopRecord((response, error) => {
      callBack(response, error)
    })
  }

  playAudio(url) {
    const fileUrl = url.substring(0, url.lastIndexOf('.')) + '.amr'
    CustomRecord.playRecord(fileUrl)
  }

  stopPlayRecord() {
    CustomRecord.stopPlayRecord()
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

const instance = new AudioRecorder()

export default instance
