import React from "react";
const CustomRecord = require('NativeModules').CustomRecord


export default AudioRecorder = {

  startRecord() {
    CustomRecord.startRecord()
  },

  stopRecord(callBack) {
    CustomRecord.stopRecord((error, response) => {
      //console.log(" response : ", response);
      if(error) {
        callBack({}, error)
      } else {
        callBack({path: response[0], size: response[1]}, error)
      }
    })
  },

  playAudio(url) {
    const fileUrl = url.substring(0, url.lastIndexOf('.')) + '.caf'
    CustomRecord.playRecord(fileUrl)
  },

  stopPlayRecord() {
    CustomRecord.stopPlayRecord()
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
