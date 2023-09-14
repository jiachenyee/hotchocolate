//
//  OnboardingView.swift
//  hotchocolate
//
//  Created by Jia Chen Yee on 14/9/23.
//

import Foundation
import SwiftUI

struct OnboardingView: View {
    
    @Environment(\.openWindow) var openWindow
    @ObservedObject var recordingManager: RecordingManager
    @State private var onboardingState = OnboardingState.connectCaptureCard
    @State private var isOutputFolderPickerPresented = false
    
    var body: some View {
        ScrollView {
            OnboardingRow(state: .connectCaptureCard,
                          currentState: $onboardingState,
                          systemImage: "cable.connector",
                          title: "1. Connect the Capture Card",
                          description: "Connect the Apple TV to a HDMI capture card and plug the Capture Card into your device.")
            .padding(.top)
            
            OnboardingRow(state: .selectCaptureCard,
                          currentState: $onboardingState,
                          systemImage: "camera",
                          title: "2. Select the Camera",
                          description: "Choose the Capture Card as the camera from the list below.") {
                
                HStack {
                    Picker(selection: $recordingManager.selectedCameraID) {
                        Text("Nothing Selected")
                            .tag("")
                        
                        ForEach(recordingManager.cameras) { camera in
                            Text(camera.name)
                        }
                    } label: {
                        EmptyView()
                    }
                    Button("Refresh") {
                        recordingManager.refreshInputDevices()
                    }
                }
            }
            
            OnboardingRow(state: .enableLoopbackMicrophone,
                          currentState: $onboardingState,
                          systemImage: "point.forward.to.point.capsulepath.fill",
                          title: "3. Enable Loopback",
                          description: "Loopback should route Krisp Microphone and the Capture Card's audio into Channels 1 & 2 (for left and right channels respectively) and route the Capture Card's audio to Channels 3 & 4. Channels 3 & 4 should be routed to Creston 420 (or other AV system) as the monitor.") {
                OnboardingLoopbackDiagram()
                    .frame(height: 200)
            }
            
            OnboardingRow(state: .selectMicrophone,
                          currentState: $onboardingState,
                          systemImage: "mic",
                          title: "4. Select the Loopback Microphone",
                          description: "Choose the Loopback Microphone you set up as the microphone from the list below.") {
                HStack {
                    Picker(selection: $recordingManager.selectedMicrophoneID) {
                        Text("Nothing Selected")
                            .tag("")
                        
                        ForEach(recordingManager.microphones) { microphone in
                            Text(microphone.name)
                        }
                    } label: {
                        EmptyView()
                    }
                    
                    Button("Refresh") {
                        recordingManager.refreshInputDevices()
                    }
                }
            }
            
            OnboardingRow(state: .configureDiscord,
                          currentState: $onboardingState,
                          systemImage: "video",
                          title: "5. Set up Discord",
                          description: "In Discord, press ⌘-, to open the Settings. Under Voice & Video, set the Input Device to the Loopback Microphone.")
            
            OnboardingRow(state: .launchDisplay,
                          currentState: $onboardingState,
                          systemImage: "macwindow",
                          title: "6. Launch Presentation Window",
                          description: "Make sure the target display is connected as \"Extended\", not \"Mirroring\".\n\nClick the button below to launch the Presentation Window.") {
                Button("Launch Presentation Window") {
                    openWindow(id: "presentation-window")
                }
                Text("Move the window to the target display and put it in full screen.")
            }
            
            OnboardingRow(state: .setOutput, 
                          currentState: $onboardingState,
                          systemImage: "doc", title: "7. Set Output Location",
                          description: "Set up where you want your files to be output.") {
                Text("\(recordingManager.outputURL?.path(percentEncoded: false) ?? "No Folder Selected")")
                Button("Choose Folder") {
                    isOutputFolderPickerPresented.toggle()
                }
                .fileImporter(isPresented: $isOutputFolderPickerPresented, allowedContentTypes: [.folder]) { result in
                    switch result {
                    case .success(let url):
                        recordingManager.outputURL = url
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
            
            OnboardingRow(state: .startSession,
                          currentState: $onboardingState,
                          systemImage: "macwindow",
                          title: "8. Start Session",
                          description: "Check that all your Capture Card and Loopback Microphone has been set up properly, the presentation window is displaying correctly (it should show the Swift Accelerator logo).\n\nWhen everything is ready, select Start to start.",
                          isNextButtonHidden: true) {
                Button("Start") {
                    guard let camera = recordingManager.cameras.first(where: { $0.id == recordingManager.selectedCameraID }),
                          let microphone = recordingManager.microphones.first(where: { $0.id == recordingManager.selectedMicrophoneID }) else { return }
                    
                    recordingManager.start(camera: camera.device, microphone: microphone.device)
                    
                    recordingManager.sessionStarted.toggle()
                }
            }
        }
    }
}
