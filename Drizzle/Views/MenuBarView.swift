//
//  MenuBarView.swift
//  Drizzle
//
//  Created by Meelunae on 23/01/24.
//

import SwiftUI

struct MenuBarView: View {
    @ObservedObject var model: PomodoroViewModel
    @AppStorage("userName") private var userName: String = ""
    var body: some View {
        VStack {
            Divider()
                .opacity(0)
            Text("\(greeting), \(userName)!\nYou have focused for 25 minutes today.")
                .monospaced()
                .scaledToFill()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.top, .bottom], 8)
                .padding([.leading, .trailing])
            Divider()
            switch model.pomodoroState {
            case .stopped:
                Button(action: {
                    model.pomodoroState = .studySessionActive
                }, label: {
                    Text("Start a new session")
                })
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.leading])
                .buttonStyle(.accessoryBar)

            case.studySessionActive:
                GaugeProgressView(title: "Time remaining for the study sprint", model: model)
                    .frame(maxWidth: .infinity, alignment: .leading)
            case .restSessionActive:
                GaugeProgressView(title: "Time remaining for the rest sprint", model: model)
            }
            Divider()
            Button(action: {
                exit(EXIT_SUCCESS)
            }, label: {
                Text("Quit Drizzle")
            })
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.leading])
            .buttonStyle(.accessoryBar)
            .keyboardShortcut("q")
            Divider()
                .opacity(0)
        }
    }
    var stopSessionButton: some View {
        Button(action: {
            model.pomodoroState = .stopped
        }, label: {
            Text("Stop this session")
        })
        .padding([.bottom])
        .keyboardShortcut("p")
    }
    var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<12:
            return "Good morning"
        case 12..<18:
            return "Good afternoon"
        case 18..<22:
            return "Good evening"
        default:
            return "Good night"
        }
    }
}

#Preview {
    MenuBarView(model: PomodoroViewModel())
}
