//
//  ContentView.swift
//  Drizzle
//
//  Created by Meelunae on 22/01/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var model: PomodoroViewModel
    @EnvironmentObject var preferences: AppPreferences
    var body: some View {
            switch model.pomodoroState {
            case .studySessionActive:
                studyView
            case .restSessionActive:
                restView
            default:
                idleView
            }
    }
}

private extension ContentView {
    @ViewBuilder
    var idleView: some View {
        VStack {
            Text("Welcome back, \(preferences.values.userName)!")
                .monospaced()
                .font(.title)
                .padding()
            Button(action: {
                model.pomodoroState = .studySessionActive
            }, label: {Text("Start a new session!")})
            Button(action: {
                if let bundleID = Bundle.main.bundleIdentifier {
                    UserDefaults.standard.removePersistentDomain(forName: bundleID)
                    preferences.reset()
                }
            }, label: {Text("Reset")})
        }
        .padding()
        .onAppear(perform: {
            model.REST_DURATION = 60 * preferences.values.restingDuration
            model.FOCUS_DURATION = 60 * preferences.values.studyDuration
        })
    }

    @ViewBuilder
    var progressView: some View {
        VStack {
            ZStack {
                withAnimation {
                    CircularProgressView(progress: $model.progress, color: $model.timerViewColor)
                }
                Text(model.timeRemaining.parsedTimestamp)
                    .font(.largeTitle)
                    .monospaced()
            }
            Button(action: {
                model.pomodoroState = .stopped
            }, label: {Text("Stop timer")})
        }
    }

    @ViewBuilder
    var restView: some View {
        VStack {
            Text("\(preferences.values.userName), get some well deserved rest!")
                .monospaced()
                .padding()
                .font(.title3)
            progressView
                .frame(width: 250, height: 250)
        }
    }

    @ViewBuilder
    var studyView: some View {
        VStack {
            Text("You can do it, \(preferences.values.userName)!")
                .monospaced()
                .padding()
                .font(.title3)
            progressView
                .frame(width: 250, height: 250)
        }
    }
}

#Preview {
    ContentView()
}
