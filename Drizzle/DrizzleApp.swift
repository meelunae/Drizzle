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
                .frame(minWidth: 500, maxWidth: 750, minHeight: 333, maxHeight: 500)
            .onAppear {
                requestNotificationPermissions()
            }
        }
        MenuBarExtra(content: {

        }, label: {
            if viewModel.pomodoroState == .stopped {
                Text("No timer running")
            } else {
                Text(viewModel.timeRemaining.parsedTimestamp)
            }
        })
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
