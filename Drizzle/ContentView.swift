//
//  ContentView.swift
//  Drizzle
//
//  Created by Meelunae on 22/01/24.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("showUserOnboarding") var showOnboarding: Bool = true
    @AppStorage("userName") private var userName: String = ""
    @ObservedObject var model: PomodoroViewModel
    var body: some View {
        if showOnboarding {
            OnboardingView()
        } else {
            if model.pomodoroState == .studySessionActive {
                VStack {
                    Text("You can do it, \(userName)!")
                        .monospaced()
                        .padding()
                        .font(.title3)
                    progressView
                        .frame(width: 250, height: 250)
                }
            } else if model.pomodoroState == .restSessionActive {
                VStack {
                    Text("\(userName), get some well deserved rest!")
                        .monospaced()
                        .padding()
                        .font(.title3)
                    progressView
                        .frame(width: 250, height: 250)
                }
            } else {
                idleView
                Button(action: {
                    if let bundleID = Bundle.main.bundleIdentifier {
                        UserDefaults.standard.removePersistentDomain(forName: bundleID)
                    }
                }, label: {Text("Safeguard")})
            }
        }
    }
    
    
    var progressView: some View {
        VStack {
            ZStack() {
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
    
    var idleView: some View {
        VStack {
            Text("Welcome back, \(userName)!")
                .monospaced()
                .font(.title)
                .padding()
            Button(action: {
                model.pomodoroState = .studySessionActive
            }, label: {Text("Start a new session!")})
        }
        .padding()
    }
}

#Preview {
    ContentView(model: PomodoroViewModel())
}
