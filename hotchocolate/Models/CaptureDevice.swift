//
//  CaptureDevice.swift
//  hotchocolate
//
//  Created by Jia Chen Yee on 14/9/23.
//

import Foundation
import AVFoundation

struct CaptureDevice: Identifiable {
    var device: AVCaptureDevice
    var name: String {
        device.localizedName
    }
    var id: String {
        device.uniqueID
    }
    
    init(_ device: AVCaptureDevice) {
        self.device = device
    }
}
