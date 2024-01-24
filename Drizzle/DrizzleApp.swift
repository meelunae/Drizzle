//
//  DrizzleApp.swift
//  Drizzle
//
//  Created by Meelunae on 22/01/24.
//

import SwiftUI
import UserNotifications

@main
struct DrizzleApp: App {
    @StateObject var viewModel = PomodoroViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView(model: viewModel)
                .frame(minWidth: 750, maxWidth: 750, minHeight: 500, maxHeight: 500)
            .onAppear {
                requestNotificationPermissions()
            }
        }
        MenuBarExtra(content: {
            MenuBarView(model: viewModel)
                .frame(minWidth: 300, maxWidth: 300, minHeight: 275, maxHeight: 275)
        }, label: {
            switch viewModel.pomodoroState {
            case .stopped:
                Image(systemName: "cloud.moon.rain")
            case .studySessionActive:
                Image(systemName: "cloud.sun.rain")
                Text(viewModel.timeRemaining.parsedTimestamp)
            case .restSessionActive:
                HStack {
                    Image(systemName: "rainbow")
                    Text(viewModel.timeRemaining.parsedTimestamp)
                }
            }
        })
        .menuBarExtraStyle(.window)
    }
}

func requestNotificationPermissions() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
        if granted {
            print("Notification permissions granted")
        } else if let error = error {
            print("Error requesting notification permissions: \(error.localizedDescription)")
        }
    }
}

extension Int {
    var parsedTimestamp: String {
        let minute = self / 60 % 60
        let second = self % 60
        return String(format: "%02i:%02i", minute, second)
    }
}
