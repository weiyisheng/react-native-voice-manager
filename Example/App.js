/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
  StyleSheet,
  Text,
  View,
  TouchableOpacity
} from 'react-native';

import { VoiceRecorder, VoicePlayer } from 'react-native-voice-manager'

class Button extends React.Component {

  render() {
    const { lable, onPress } = this.props
    return (
      <View style={[styles.center, styles.buttonBox]}>
        <TouchableOpacity
          onPress={onPress}
          style={[styles.center, styles.button]}>
          <Text style={styles.buttonText}>{lable}</Text>
        </TouchableOpacity>
      </View>

    )
  }
}

export default class App extends Component {

  constructor(props) {
    super(props)

    this.state = {
      voices: [],
      power: {}
    }
  }

  render() {
    return (
      <View style={styles.container}>
        <Button
          lable={"开始录音"}
          onPress={() => {
            VoiceRecorder.startRecording(event => {
              this.setState({
                power: event.power
              })
            })
          }}/>
        <Button
          lable={"结束录音"}
          onPress={() => {
            VoiceRecorder.stopRecording((error, response) => {
              console.log(" response : ", response);
              if(response) {
                const newVoice = this.state.voices
                newVoice.push(response[0])
                this.setState({
                  voices: newVoice
                })
              }
            })
          }}/>
          <Text>peakPower: {this.state.power.peak}</Text>
          <Text>averagePower: {this.state.power.average}</Text>
          {
              this.state.voices.map(voicePath =>
                <TouchableOpacity
                  key={voicePath}
                  onPress={() => {
                    VoicePlayer.startPlaying(voicePath)
                  }}>
                  <Text style={styles.pathText}>{voicePath}</Text>
                </TouchableOpacity>
              )
          }
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 20,
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
  center: {
    justifyContent: "center",
    alignItems: "center"
  },
  buttonBox: {
    marginTop: 20
  },
  button: {
    height: 40,
    width: 180,
    backgroundColor: "#48a050"
  },
  buttonText: {
    fontSize: 15,
    color: "#fff"
  },
  pathText: {
    color: "#000"
  }
});
