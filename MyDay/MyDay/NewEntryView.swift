//
//  NewEntryView.swift
//  MyDay
//
//  Created by Stefanie on 25.12.23.
//

import SwiftUI
import PhotosUI

struct NewEntryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @State var entryName: String = ""
    @State var entryContent: String = ""
    var today = Date()
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var imageView: Image?
    @State private var imageAsUIImage: UIImage? = nil
    @StateObject private var audioModel = AudioModel()
    private var entryID = UUID()
    
    var body: some View {
        VStack{
            HStack{
                Text(NSLocalizedString("new_entry_view_title", comment: ""))
                    .font(.largeTitle)
            }
            Group{
                HStack{
                    Text(NSLocalizedString("entry_name_label", comment: ""))
                    TextField("", text: $entryName)
                        .textFieldStyle(.roundedBorder)
                }
                Spacer().frame(height: 20)
                Text(NSLocalizedString("entry_content_label", comment: ""))
                HStack{
                    
                    TextEditor(text: $entryContent)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke().opacity(0.1)
                        )
                }
            }
            
            Spacer().frame(height: 20.0)
            imageView?
                .resizable()
                .scaledToFit()
            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                Label(NSLocalizedString("photo_selection_button", comment: ""), systemImage: "photo.fill.on.rectangle.fill")
            }
            Spacer()
                .frame(height: 20.0)
            HStack{
                
            }
            HStack{
                Group{
                    if audioModel.isRecording {
                        Button {
                            audioModel.stopRecording()
                        } label: {
                            Label(NSLocalizedString("stop_recording_label", comment: ""), systemImage: "record.circle.fill")
                        }
                    } else {
                        Button {
                            audioModel.startRecording(entryID: entryID)
                        } label: {
                            Label(NSLocalizedString("start_recording_label", comment: ""), systemImage: "record.circle")
                        }
                    }
                    Spacer().frame(width: 20.0)
                }
            }
            Spacer()
                .frame(height: 40.0)
            Button{
                addItem(name: entryName, content: entryContent, image: imageAsUIImage)
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text(NSLocalizedString("add_button", comment: ""))
            }
            
        }
        .padding()
        .onChange(of: selectedPhoto) { newItem in
            Task {
                if let imageData = try? await newItem?.loadTransferable(type: Data.self) {
                    imageAsUIImage = UIImage(data: imageData)
                    imageView = Image(uiImage: imageAsUIImage ?? UIImage()) // Use a default image if imageAsUIImage is nil
                } else {
                    // Handle the case where no image is selected
                    imageAsUIImage = nil
                    imageView = nil
                }
            }
        }


    }
    
    private func addItem(name: String, content: String, image: UIImage?) {
        withAnimation {
            let newItem = Entry(context: viewContext)
            newItem.id = entryID
            newItem.date = today
            newItem.name = name
            newItem.content = content
            newItem.image = image?.jpegData(compressionQuality: 1.0)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}


