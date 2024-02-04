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
    var preferences = AppPreferences()
    var viewModel = PomodoroViewModel()
    var body: some Scene {
        WindowGroup {
            if preferences.showOnboarding {
                OnboardingView()
                    .environmentObject(preferences)
                    .frame(minWidth: 750, maxWidth: 750, minHeight: 500, maxHeight: 500)
            } else {
                ContentView()
                    .environmentObject(preferences)
                    .environmentObject(viewModel)
                    .frame(minWidth: 750, maxWidth: 750, minHeight: 500, maxHeight: 500)
                .onAppear {
                    requestNotificationPermissions()
                    setLastSeenActivity()
                }
            }
        }
        .defaultSize(width: 750, height: 500)
        .windowResizability(.contentSize)
        .windowStyle(HiddenTitleBarWindowStyle())
        MenuBarExtra(content: {
            MenuBarView(model: viewModel)
            .background(IdleGradientBackground())
                .frame(minWidth: 350, maxWidth: 350)
        }, label: {
            switch viewModel.pomodoroState {
            case .stopped:
                Image("CloudIcon")
                .padding()
            case .studySessionActive:
                HStack {
                    Image("RainIcon")
                    Text(viewModel.timeRemaining.parsedTimestamp)
                }
                .padding()
            case .restSessionActive:
                HStack {
                    Image("SunIcon")
                    Text(viewModel.timeRemaining.parsedTimestamp)
                }
                .padding()
            }
        })
        .menuBarExtraStyle(.window)
    }

    func setLastSeenActivity() {
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayString = dateFormatter.string(from: today)
        // Convert date strings to Date objects
        if let date1 = dateFormatter.date(from: preferences.lastFocusedDate),
           let date2 = dateFormatter.date(from: todayString) {
            let comparisonResult = date1.compare(date2)
            // In this case, the app was not launched yet today, and we adjust our AppStorage accordingly.
            if comparisonResult == .orderedAscending {
                preferences.lastFocusedDate = todayString
                preferences.lastFocusedMinutes = 0
            }
        } else {
            print("Invalid date strings")
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
}
