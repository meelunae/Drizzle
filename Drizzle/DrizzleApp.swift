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
    @AppStorage("showUserOnboarding") var showOnboarding: Bool = true
    @StateObject var viewModel = PomodoroViewModel()
    var body: some Scene {
        WindowGroup {
            if showOnboarding {
                OnboardingView()
            } else {
                ContentView(model: viewModel)
                .onAppear {
                    requestNotificationPermissions()
                    setLastSeenActivity()
                }
            }
        }
        .defaultSize(width: 750, height: 500)
        .windowStyle(HiddenTitleBarWindowStyle())
        MenuBarExtra(content: {
            MenuBarView(model: viewModel)
            .background(
                LinearGradient(gradient: Gradient(colors: [
                    Color(.idleGradientPrimary),
                    Color(.idleGradientSecondary)]
                ),
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
