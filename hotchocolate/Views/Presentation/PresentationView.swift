//
//  PresentationView.swift
//  hotchocolate
//
//  Created by Jia Chen Yee on 14/9/23.
//

import SwiftUI

struct PresentationView: View {
    
    @ObservedObject var recordingManager: RecordingManager
    
    var body: some View {
        GeometryReader { geometry in
            let sizeUnit = geometry.size.width / 1920
            if recordingManager.sessionStarted {
                if let session = recordingManager.session {
                    CapturePreview(session: session)
                } else {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .scaleEffect(sizeUnit * 4)
                }
            } else {
                Image(.logo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: sizeUnit * 300, height: sizeUnit * 300)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .aspectRatio(16/9, contentMode: .fit)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.solidBackground)
    }
}

#Preview {
    PresentationView(recordingManager: .init())
}
