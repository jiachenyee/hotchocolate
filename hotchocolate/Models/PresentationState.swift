//
//  OnboardingState.swift
//  hotchocolate
//
//  Created by Jia Chen Yee on 14/9/23.
//

import Foundation

enum OnboardingState: Int {
    case connectCaptureCard
    case selectCaptureCard
    case enableLoopbackMicrophone
    case selectMicrophone
    case configureDiscord
    case launchDisplay
    case setOutput
    case startSession
    
    mutating func next() {
        self = Self(rawValue: self.rawValue + 1) ?? self
    }
    
    mutating func previous() {
        self = Self(rawValue: self.rawValue - 1) ?? self
    }
}
