//
//  AudioModel.swift
//  MyDay
//
//  Created by Stefanie on 01.01.24.
//

import Foundation
import AVFoundation

class AudioModel : NSObject, ObservableObject, AVAudioPlayerDelegate {
    
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    var soundFileUrl = URL(string: "")
    
    @Published var isRecording: Bool = false
    @Published var isPlaying: Bool = false
    @Published var curentEntryID: UUID?
    
    func startRecording(entryID: UUID) {
        
        self.curentEntryID = entryID;
        let recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Can not setup the recording session!")
        }
        
        
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        self.soundFileUrl = path.appendingPathComponent("\(self.curentEntryID!.uuidString).m4a")
        
        print(path)
        
        let audioSettings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            self.audioRecorder = try AVAudioRecorder(url: self.soundFileUrl!, settings: audioSettings)
            self.audioRecorder.prepareToRecord()
            self.audioRecorder.record()
            self.isRecording = true
            
        } catch {
            print("Failed to setup audio recording!")
        }
    }
    
    func stopRecording() {
        self.curentEntryID = nil
        self.audioRecorder.stop()
        self.isRecording = false
    }
    
    func startPlaying(audioFile: String) {
        
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        self.soundFileUrl = path.appendingPathComponent("\(audioFile).m4a")
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: self.soundFileUrl!)
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            isPlaying = true
        } catch {
            print("Failed to play audio file!")
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
    }
    
}
