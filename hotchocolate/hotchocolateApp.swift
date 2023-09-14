//
//  hotchocolateApp.swift
//  hotchocolate
//
//  Created by Jia Chen Yee on 14/9/23.
//

import SwiftUI

@main
struct hotchocolateApp: App {
    
    @StateObject var recordingManager = RecordingManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView(recordingManager: recordingManager)
        }
        
        WindowGroup(id: "presentation-window") {
            PresentationView(recordingManager: recordingManager)
        }
    }
}
