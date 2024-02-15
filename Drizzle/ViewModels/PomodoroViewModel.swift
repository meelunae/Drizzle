//
//  PomodoroViewModel.swift
//  Drizzle
//
//  Created by Meelunae on 22/01/24.
//

import SwiftUI

final class PomodoroViewModel: ObservableObject {
    enum PomodoroState {
        case studySessionActive
        case restSessionActive
        case stopped
    }

    var appPreferences: AppPreferences?
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
                    self.processSessionStatus()
                }
            }
            RunLoop.current.add(pomodoro, forMode: .default)
            RunLoop.current.run()
        }
    }

    func processSessionStatus() {
        switch self.pomodoroState {
        case .studySessionActive:
            self.progress = Float(self.timeRemaining) / Float(self.FOCUS_DURATION)
            if self.timeRemaining < 0 {
                if let appPreferences = self.appPreferences {
                    appPreferences.focusMinsToday += appPreferences.studyDuration
                    self.pomodoro.invalidate()
                    sendLocalNotification(
                        title: "You did it!",
                        body: """
                        Your \(appPreferences.studyDuration) minute\(appPreferences.studyDuration == 1 ? "" : "s") study sprint is over.
                        Enjoy a well-deserved \(appPreferences.restingDuration) minute\(appPreferences.restingDuration == 1 ? "" : "s") break!
                        """)
                    self.pomodoroState = .restSessionActive
                }
            }
        case .restSessionActive:
            self.progress = Float(self.timeRemaining) / Float(self.REST_DURATION)
            if self.timeRemaining < 0 {
                if let appPreferences = self.appPreferences {
                    appPreferences.restMinsToday += appPreferences.restingDuration
                    sendLocalNotification(
                        title: "Let's get back to work!",
                        body: """
                        "Your \(appPreferences.restingDuration)
                        \(appPreferences.restingDuration == 1 ? "minute" : "minutes") resting sprint is over.
                        """)
                    self.pomodoroState = .stopped
                }
            }
        case .stopped:
            // should never reach here
            break
        }
    }
}
