//
//  PomodoroViewModel.swift
//  Drizzle
//
//  Created by Meelunae on 22/01/24.
//

import SwiftUI
import UserNotifications

final class PomodoroViewModel: ObservableObject {
    enum PomodoroState {
        case studySessionActive
        case restSessionActive
        case stopped
    }
    @AppStorage("lastSeenFocusTime") var lastFocusedMinutes: Int = 0
    @Published var timeRemaining = 0
    @Published var progress: Float = 0.0
    @Published var timerViewColor: Color = .orange // default is study
    @Published var pomodoroState: PomodoroState = .stopped {
        didSet {
            switch pomodoroState {
            case .studySessionActive:
                timerViewColor = .orange
                startTimer()
                timeRemaining = FOCUS_DURATION
                progress = 1.0
            case .restSessionActive:
                timerViewColor = .green
                timeRemaining = REST_DURATION
                progress = 1.0
                startTimer()
            case .stopped:
                pomodoro.invalidate()
                timeRemaining = 0
                progress = 0
            }
        }
    }
    private var pomodoro = Timer()
    var FOCUS_DURATION: Int = 0
    var REST_DURATION: Int = 0
    private func startTimer() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }

            // Schedule the timer on the current run loop of the background thread
            pomodoro = Timer(timeInterval: 1.0, repeats: true) { [weak self] _ in
                guard let self = self else { return }

                DispatchQueue.main.async {
                    self.timeRemaining -= 1
                    switch self.pomodoroState {
                    case .studySessionActive:
                        self.progress = Float(self.timeRemaining) / Float(self.FOCUS_DURATION)
                        if self.timeRemaining < 0 {
                            // dividing total number of seconds by 60 to avoid declaring variables for the minutes count
                            self.lastFocusedMinutes += self.FOCUS_DURATION / 60
                            self.pomodoro.invalidate()
                            self.sendLocalNotification(
                                title: "You did it!",
                                body: "Your 25 minutes study sprint is over. Enjoy a well-deserved 5 minutes break!"
                            )
                            self.pomodoroState = .restSessionActive
                        }
                    case .restSessionActive:
                        self.progress = Float(self.timeRemaining) / Float(self.REST_DURATION)
                        if self.timeRemaining < 0 {
                            self.sendLocalNotification(
                                title: "Let's get back to work!",
                                body: "Your 5 minutes resting sprint is over.")
                            self.pomodoroState = .stopped
                        }
                    case .stopped:
                        // should never reach here
                        break
                    }
                }
                }

            RunLoop.current.add(pomodoro, forMode: .default)
            RunLoop.current.run()
        }
    }

    func sendLocalNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        // Time Sensitive interruption level so that the notification of the timers ending shows up on every focus.
        content.interruptionLevel = .timeSensitive

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "successNotification", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error adding notification request: \(error.localizedDescription)")
            }
        }
    }
}
