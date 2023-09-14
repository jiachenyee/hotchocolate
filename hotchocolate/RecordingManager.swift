//
//  RecordingManager.swift
//  hotchocolate
//
//  Created by Jia Chen Yee on 14/9/23.
//

import Foundation
import AVFoundation
import SwiftUI

class RecordingManager: NSObject, ObservableObject {
    
    @Published var sessionStarted = false
    
    var session: AVCaptureSession?
    private var movieOutput: AVCaptureMovieFileOutput?
    
    @Published var isRecording = false
    
    @Published var cameras: [CaptureDevice] = []
    @Published var microphones: [CaptureDevice] = []
    
    @Published var selectedCameraID = ""
    @Published var selectedMicrophoneID = ""
    
    @Published var outputURL: URL?
    
    override init() {
        super.init()
        updateCamerasList()
        updateMicrophonesList()
        requestAuthorization()
    }
    
    func requestAuthorization() {
        switch AVCaptureDevice.authorizationStatus(for: .audio) {
        case .authorized:
            break
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .audio) { granted in
            }
        default: break
        }
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            break
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
            }
        default: break
        }
    }
    
    func updateCamerasList() {
        cameras = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera, .externalUnknown],
                                                   mediaType: .video,
                                                   position: .unspecified)
        .devices
        .map { CaptureDevice($0) }
    }
    
    func updateMicrophonesList() {
        microphones = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInMicrophone, .externalUnknown],
                                                       mediaType: .audio,
                                                       position: .unspecified)
        .devices
        .map { CaptureDevice($0) }
    }
    
    func refreshInputDevices() {
        updateCamerasList()
        updateMicrophonesList()
    }
    
    func start(camera: AVCaptureDevice, microphone: AVCaptureDevice) {
        session = AVCaptureSession()
        
        do {
            let cameraInput = try AVCaptureDeviceInput(device: camera)
            let microphoneInput = try AVCaptureDeviceInput(device: microphone)
            
            if let session = session {
                if session.canAddInput(cameraInput) {
                    session.addInput(cameraInput)
                } else {
                    print("Could not add cam input")
                }
                
                if session.canAddInput(microphoneInput) {
                    session.addInput(microphoneInput)
                } else {
                    print("Could not add mic input")
                }
                
                movieOutput = AVCaptureMovieFileOutput()
                
                if session.canAddOutput(movieOutput!) {
                    session.addOutput(movieOutput!)
                }
                
                movieOutput?.maxRecordedDuration = CMTimeMake(value: Int64(6 * 60 * 60), timescale: 1)
                
                session.startRunning()
            }
        } catch {
            print("Error setting up recording session: \(error)")
        }
    }
    
    func startRecording(fileName: String) {
        let finalOutputURL = URL.temporaryDirectory.appendingPathComponent("RawVideo/\(fileName).mov")
        movieOutput?.startRecording(to: finalOutputURL, recordingDelegate: self)
        
        isRecording = true
    }
    
    func stop() {
        guard let movieOutput = movieOutput else { return }
        movieOutput.stopRecording()
        
        isRecording = false
    }
    
    func handbrake(fileURL: URL, output: URL) {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/opt/homebrew/bin/HandBrakeCLI")
        process.arguments = [
            "-i", fileURL.path,
            "-o", output.path,
            "--preset", "Fast 1080p30"
        ]
        
        do {
            try process.run()
            process.waitUntilExit()
            
            if process.terminationStatus == 0 {
                print("HandBrakeCLI ran successfully.")
            } else {
                print("HandBrakeCLI failed with exit code \(process.terminationStatus).")
            }
        } catch {
            print("Failed to run HandBrakeCLI: \(error)")
        }
    }

}

extension RecordingManager: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print("Error recording: \(error)")
        } else {
            print("Recording finished successfully. File saved to: \(outputFileURL)")
            
            var fileName = outputFileURL.lastPathComponent
            fileName.removeLast(2)
            fileName += "p4"
            
            guard let url = outputURL?.appendingPathComponent(fileName) else { return }
            print("Beginning Handbrake on \(outputFileURL.lastPathComponent)")
            
            handbrake(fileURL: outputFileURL, output: url)
        }
    }
}
