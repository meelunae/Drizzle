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
                .background(
                     LinearGradient(gradient: Gradient(colors: [Color(hex: 0x6274e7), Color(hex: 0x28b8d5)]),
                         startPoint: .topLeading,
                         endPoint: .bottomTrailing)
                     .opacity(0.8)
                     .edgesIgnoringSafeArea(.all))
                .frame(minWidth: 350, maxWidth: 350)
        }, label: {
            switch viewModel.pomodoroState {
            case .stopped:
                Image("CloudIcon")
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
}

func setLastSeenActivity() {
    let today = Date()
    let initialEpochDate = Date(timeIntervalSince1970: 0)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let todayString = dateFormatter.string(from: today)
    @AppStorage("lastSeenDate") var lastFocusedDate: String = dateFormatter.string(from: initialEpochDate)
    @AppStorage("lastSeenFocusTime") var lastFocusedMinutes: Int = 0
    // Convert date strings to Date objects
    if let date1 = dateFormatter.date(from: lastFocusedDate),
       let date2 = dateFormatter.date(from: todayString) {
        let comparisonResult = date1.compare(date2)
        // In this case, the app was not launched yet today, and we adjust our AppStorage accordingly.
        if comparisonResult == .orderedAscending {
            lastFocusedDate = todayString
            lastFocusedMinutes = 0
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
