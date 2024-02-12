//
//  SettingsView.swift
//  Drizzle
//
//  Created by Meelunae on 04/02/24.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var model: PomodoroViewModel
    @EnvironmentObject var preferences: AppPreferences
    @EnvironmentObject var navigationManager: NavigationStateManager
    var body: some View {
        VStack {
            StepperView(label: "Study sprints:",
                        minValue: 5,
                        maxValue: 30,
                        currentValue: $preferences.studyDuration
            )
                .monospaced()
                .font(.title3)
                .padding()
            StepperView(label: "Resting sprints:",
                        minValue: 5,
                        maxValue: 30,
                        currentValue: $preferences.restingDuration)
                .monospaced()
                .font(.title3)
                .padding()
            HStack {
                Spacer()
                Button(action: {
                    navigationManager.selectionState = .home
                }, label: {
                    Text("Save")
                })
                .monospaced()
                .font(.title3)
                .padding()
                .buttonStyle(PlainButtonStyle())
                .overlay(
                    RoundedRectangle(
                        cornerRadius: 12,
                        style: .continuous
                    )
                    .stroke(Color.white, lineWidth: 1)
                    .background(Color.clear)
                )
                Spacer()
            }
        }
        .padding()
    }
}
