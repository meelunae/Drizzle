//
//  Backgrounds.swift
//  Drizzle
//
//  Created by Meelunae on 02/02/24.
//

import SwiftUI

struct IdleGradientBackground: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [
            Color(.idleGradientPrimary),
            Color(.idleGradientSecondary)]
            ),
            startPoint: .topLeading,
            endPoint: .bottomTrailing)
        .opacity(0.8)
        .edgesIgnoringSafeArea(.all)
}
}
