//
//  Extensions.swift
//  Drizzle
//
//  Created by Meelunae on 01/02/24.
//

import SwiftUI

extension Int {
    var parsedTimestamp: String {
        let minute = self / 60 % 60
        let second = self % 60
        return String(format: "%02i:%02i", minute, second)
    }
}

extension Color {
    init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex & 0xff0000) >> 16) / 255.0
        let green = Double((hex & 0xff00) >> 8) / 255.0
        let blue = Double((hex & 0xff) >> 0) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}
