//
//  AppPreferences.swift
//  Drizzle
//
//  Created by Meelunae on 05/02/24.
//
import SwiftUI

final class AppPreferences: ObservableObject {
    @AppStorage("isPendingOnboarding") var showOnboarding: Bool = true
    @AppStorage("studyDuration") var studyDuration: Int = 5
    @AppStorage("restingDuration") var restingDuration: Int = 5
    @AppStorage("userName") var userName: String = ""
    @AppStorage("focusTimeToday") var focusMinsToday: Int = 0
    @AppStorage("restTimeToday") var restMinsToday: Int = 0
    @AppStorage("sessionsToday") var nOfSessionsToday: Int = 0

    func resetAllSettings() {
        self.showOnboarding = true
        self.studyDuration = 5
        self.restingDuration = 5
        self.userName = ""
        self.focusMinsToday = 0
        self.restMinsToday = 0
    }

    func refreshDailyValues() {
        self.focusMinsToday = 0
        self.restMinsToday = 0
        self.nOfSessionsToday = 0
    }
}
