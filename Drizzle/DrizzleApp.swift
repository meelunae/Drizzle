//
//  DrizzleApp.swift
//  Drizzle
//
//  Created by Meelunae on 22/01/24.
//

import SwiftUI

@main
struct DrizzleApp: App {
    @StateObject var preferences = AppPreferences()
    @StateObject var pomodoroInstance = PomodoroViewModel()
    @StateObject var userHistory = HistoryViewModel()
    var body: some Scene {
        WindowGroup {
            if preferences.showOnboarding {
                OnboardingView()
                    .frame(minWidth: 750, maxWidth: 750, minHeight: 500, maxHeight: 500)
            } else {
                ContentView()
                    .frame(minWidth: 750, maxWidth: 750, minHeight: 500, maxHeight: 500)
                .onAppear {
                    userHistory.appPreferences = preferences
                    requestNotificationPermissions()
                    userHistory.syncHistoryData()
                }
                .onReceive(NotificationCenter.default.publisher(for: NSApplication.willTerminateNotification)) { _ in
                    print("Syncing history data before closing")
                    userHistory.syncHistoryData()
                    print(userHistory.history[0])
                    userHistory.saveData(data: userHistory.history)
                }
            }
        }
        .defaultSize(width: 750, height: 500)
        .environmentObject(userHistory)
        .environmentObject(preferences)
        .environmentObject(pomodoroInstance)
        .windowResizability(.contentSize)
        .windowStyle(HiddenTitleBarWindowStyle())

        MenuBarExtra(content: {
            MenuBarView()
            .background(IdleGradientBackground())
            .frame(minWidth: 350, maxWidth: 350)
            .environmentObject(preferences)
            .environmentObject(pomodoroInstance)
        }, label: {
            switch pomodoroInstance.pomodoroState {
            case .stopped:
                Image("CloudIcon")
                .padding()
            case .studySessionActive:
                HStack {
                    Image("RainIcon")
                    Text(pomodoroInstance.timeRemaining.parsedTimestamp)
                }
                .padding()
            case .restSessionActive:
                HStack {
                    Image("SunIcon")
                    Text(pomodoroInstance.timeRemaining.parsedTimestamp)
                }
                .padding()
            }
        })
        .menuBarExtraStyle(.window)
    }
}
