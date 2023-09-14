//
//  RecordingSessionView.swift
//  hotchocolate
//
//  Created by Jia Chen Yee on 14/9/23.
//

import SwiftUI

struct RecordingSessionView: View {
    
    @ObservedObject var recordingManager: RecordingManager
    
    @State private var fileName = ""
    
    var body: some View {
        if recordingManager.isRecording {
            VStack {
                Text(fileName)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                Button(role: .destructive) {
                    recordingManager.stop()
                } label: {
                    VStack {
                        HStack {
                            Image(systemName: "stop.fill")
                            Text("Stop Recording")
                        }
                        .font(.title)
                        .fontWeight(.bold)
                        
                        Text("\(Image(systemName: "command"))S")
                            .font(.title2)
                    }
                    .padding()
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
                .keyboardShortcut("s", modifiers: .command)
            }
        } else {
            VStack {
                TextField("Lesson X-Y - Title", text: $fileName)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .border(.gray)
                    .padding()
                
                Button {
                    recordingManager.startRecording(fileName: fileName)
                } label: {
                    VStack {
                        HStack {
                            Image(systemName: "rectangle.inset.badge.record")
                            Text("Start Recording")
                        }
                        .font(.title)
                        .fontWeight(.bold)
                        
                        Text("\(Image(systemName: "command"))S")
                            .font(.title2)
                    }
                    .padding()
                }
                .buttonStyle(.borderedProminent)
                .foregroundStyle(.blue)
                .disabled(fileName.isEmpty)
                .keyboardShortcut("s", modifiers: .command)
            }
        }
    }
}

#Preview {
    RecordingSessionView(recordingManager: .init())
}
