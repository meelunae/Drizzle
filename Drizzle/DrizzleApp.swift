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
                setLastSeenActivity()
            }
        }
        MenuBarExtra(content: {
            MenuBarView(model: viewModel)
                .frame(minWidth: 350, maxWidth: 350)
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

func setLastSeenActivity() {
    @AppStorage("lastSeenDate") var lastFocusedDate: String = ""
    @AppStorage("lastSeenFocusTime") var lastFocusedMinutes: Int = 0
    if !lastFocusedDate.isEmpty {
        // if we get in here the app has already been launched before and AppStorage variable is set.
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayString = dateFormatter.string(from: today)
        // Convert date strings to Date objects
        if let date1 = dateFormatter.date(from: lastFocusedDate),
            let date2 = dateFormatter.date(from: todayString) {
            let comparisonResult = date1.compare(date2)
            if comparisonResult == .orderedSame {
                print("Dates are equal")
            } else if comparisonResult == .orderedAscending {
                // In this case, the app was not launched yet today, and we adjust our AppStorage accordingly.
                lastFocusedDate = todayString
                lastFocusedMinutes = 0
            } else {
                print("Something went wrong; this should not happen ever.")
            }
        } else {
            print("Invalid date strings")
        }
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
