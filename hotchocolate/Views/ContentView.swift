//
//  ContentView.swift
//  hotchocolate
//
//  Created by Jia Chen Yee on 14/9/23.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var recordingManager: RecordingManager
    
    var body: some View {
        if recordingManager.sessionStarted {
            RecordingSessionView(recordingManager: recordingManager)
        } else {
            OnboardingView(recordingManager: recordingManager)
        }
    }
}

#Preview {
    ContentView(recordingManager: .init())
}
