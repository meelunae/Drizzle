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
            VStack {
                Text("\(greeting), \(userName)!")
                    .monospaced()
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("You have focused for 25 minutes today.")
                    .monospaced()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
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
                HStack {
                    Text("You're doing great! :>")
                    Spacer()
                }
                .monospaced()
                .font(.callout)
                .padding([.bottom, .leading], 8)
                stopSessionButton

            case .restSessionActive:
                GaugeProgressView(title: "Time remaining for the rest sprint", model: model)
                HStack {
                    Text("Time to get some rest!")
                    Spacer()
                }
                .monospaced()
                .font(.callout)
                .padding([.bottom, .leading], 8 )
                stopSessionButton
            }
            Divider()
            Button(action: {
                exit(EXIT_SUCCESS)
            }, label: {
                Text("Quit Drizzle")
            })
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.leading, .bottom])
            .buttonStyle(.accessoryBar)
            .keyboardShortcut("q")
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
