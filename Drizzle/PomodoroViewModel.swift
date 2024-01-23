//
//  PomodoroViewModel.swift
//  Drizzle
//
//  Created by Meelunae on 22/01/24.
//

import SwiftUI
import UserNotifications

final class PomodoroViewModel: ObservableObject {
    let FOCUS_DURATION = 1 * 10 // 25 minutes
    let REST_DURATION = 5 * 60
    
    enum PomodoroState {
        case studySessionActive
        case restSessionActive
        case stopped
    }
    
    private var pomodoro = Timer()
    @Published var pomodoroState: PomodoroState = .stopped {
        didSet {
            switch pomodoroState {
                case .studySessionActive:
                    timerViewColor = .orange
                    startTimer()
                    timeRemaining = FOCUS_DURATION;
                    progress = 1.0
                case .restSessionActive:
                    timerViewColor = .green
                    timeRemaining = REST_DURATION;
                    progress = 1.0;
                    startTimer()
                case .stopped:
                    pomodoro.invalidate()
                    timeRemaining = 0
                    progress = 0
            }
        }
    }

    @Published var timeRemaining = 0
    @Published var parsedTimeRemaining = "0"
    @Published var progress: Float = 0.0
    @Published var timerViewColor: Color = .orange // default is study
    
    private func startTimer() {
        pomodoro = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] _ in
            guard let self else { return }
            self.timeRemaining -= 1
            
            switch pomodoroState {
            case .studySessionActive:
                self.progress = Float(self.timeRemaining) / Float(self.FOCUS_DURATION)
                if self.timeRemaining < 0 {
                    pomodoro.invalidate()
                    self.sendLocalNotification(title: "You did it!", body: "Your 25 minutes study sprint is over. Enjoy a well deserved 5 minutes break!")
                    self.pomodoroState = .restSessionActive
                }
            case .restSessionActive:
                self.progress = Float(self.timeRemaining) / Float(self.REST_DURATION)
                if self.timeRemaining < 0 {
                    self.sendLocalNotification(title: "Let's get back to work!", body: "Your 5 minutes resting sprint is over.")
                    self.pomodoroState = .stopped
                }
            case .stopped:
                // should never reach here
                break
            }
        })
    }
    
    func sendLocalNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        let request = UNNotificationRequest(identifier: "successNotification", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error adding notification request: \(error.localizedDescription)")
            } else {
                print("Notification request added successfully")
            }
        }
    }
}
