//
//  LogValue.swift
//  hotchocolate
//
//  Created by Jia Chen Yee on 14/9/23.
//

import Foundation
import SwiftUI
struct LogValue: Identifiable {
    var id = UUID()
    var systemImage: String
    var color: Color = .primary
    
    var title: String
    var description: String
}
