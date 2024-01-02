//
//  ShowEntryView.swift
//  MyDay
//
//  Created by Stefanie on 27.12.23.
//

import SwiftUI

struct ShowEntryView: View {
    var entry: Entry
    @State private var imageView: Image?
    @State private var existsAudioFile: Bool = false
    @StateObject private var audioModel = AudioModel()
    
    var body: some View {
        VStack{
            HStack{
                Text(entry.name ?? "")
                    .font(.largeTitle)
            }
            Spacer().frame(height: 20.0)
            HStack{
                Text("\(entry.date!.formatted())")
            }
            Spacer().frame(height: 20.0)
            HStack{
                Text(entry.content ?? "")
            }
            Spacer().frame(height: 20.0)
            imageView?
                .resizable()
                .scaledToFit()
            Spacer().frame(height: 20.0)
            HStack{
                Button{
                    audioModel.startPlaying(audioFile: entry.id!.uuidString)
                } label: {
                    Label(NSLocalizedString("play_label", comment: ""), systemImage: "play.fill")
                }
                .disabled(!existsAudioFile || audioModel.isPlaying)
            }
            
        }
        .padding()
        .onAppear{
            checkForAudioFile()
        }
        Spacer()
    }
    
    func getImage() {
        if let data = entry.image {
            let imageAsUIImage = UIImage(data: data)
            self.imageView = Image(uiImage: imageAsUIImage ?? UIImage())           
        }
        
    }
    
    func checkForAudioFile(){
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let soundFileUrl = path.appendingPathComponent("\(entry.id!.uuidString).m4a").path()
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: soundFileUrl){
            self.existsAudioFile = true
        }
    }
}


