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
    @Published var logs: [LogValue] = []
    
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
                    logs.insert(LogValue(systemImage: "xmark.circle.fill", color: .red, title: "Failed to add Camera", description: "Could not add camera input"), at: 0)
                }
                
                if session.canAddInput(microphoneInput) {
                    session.addInput(microphoneInput)
                } else {
                    logs.insert(LogValue(systemImage: "mic.badge.xmark", color: .red, title: "Failed to add Microphone", description: "Could not add microphone input"), at: 0)
                }
                
                movieOutput = AVCaptureMovieFileOutput()
                
                if session.canAddOutput(movieOutput!) {
                    session.addOutput(movieOutput!)
                } else {
                    logs.insert(LogValue(systemImage: "record.circle", color: .red, title: "Failed to add recording output", description: "Recording capabilities may be limited. Restart the app and retry."), at: 0)
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
        
        logs.insert(LogValue(systemImage: "flag.checkered.2.crossed", title: "Recording Started", description: "Recording \(fileName) started successfully. Writing to [File](\(finalOutputURL))."), at: 0)
        
        isRecording = true
    }
    
    func stop() {
        guard let movieOutput = movieOutput else { return }
        movieOutput.stopRecording()
        
        logs.insert(LogValue(systemImage: "stop.fill", title: "Stopping Recording", description: "Command issued to stop recording."), at: 0)
        
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
        
        Task(priority: .utility) {
            do {
                try process.run()
                process.waitUntilExit()
                
                if process.terminationStatus == 0 {
                    print("HandBrakeCLI ran successfully.")
                    
                    await MainActor.run {
                        logs.insert(LogValue(systemImage: "checkmark.circle", color: .green, title: "HandBrake Compression Successful", description: "[Open File](\(output))"), at: 0)
                    }
                } else {
                    print("HandBrakeCLI failed with exit code \(process.terminationStatus).")
                    
                    await MainActor.run {
                        logs.insert(LogValue(systemImage: "exclamationmark.circle", color: .red, title: "HandBrake Failed", description: "Exit Code: \(process.terminationStatus)\n\nstdout:\(process.standardOutput ?? "")"), at: 0)
                    }
                }
            } catch {
                print("Failed to run HandBrakeCLI: \(error)")
            }
        }
    }

}

extension RecordingManager: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print("Error recording: \(error)")
            logs.insert(LogValue(systemImage: "exclamationmark.octagon.fill", color: .red, title: "Error saving recording", description: "\(error.localizedDescription).\n\n[Open potentially broken file](\(outputFileURL))"), at: 0)
        } else {
            print("Recording finished successfully. File saved to: \(outputFileURL)")
            
            logs.insert(LogValue(systemImage: "movieclapper", title: "Recording Saved Successfully", description: "Raw temporary file saved to [Open File](\(outputFileURL)).\n\nStarting HandBrake on \(outputFileURL.lastPathComponent)"), at: 0)
            
            var fileName = outputFileURL.lastPathComponent
            fileName.removeLast(2)
            fileName += "p4"
            
            guard let url = outputURL?.appendingPathComponent(fileName) else { return }
            print("Beginning Handbrake on \(outputFileURL.lastPathComponent)")
            
            handbrake(fileURL: outputFileURL, output: url)
        }
    }
}
