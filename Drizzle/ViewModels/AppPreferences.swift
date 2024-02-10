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
    @AppStorage("lastSeenDate") var lastFocusedDate: String = "1970-01-01"
    @AppStorage("lastSeenFocusTime") var lastFocusedMinutes: Int = 0

    func reset() {
        self.showOnboarding = true
        self.studyDuration = 5
        self.restingDuration = 5
        self.userName = ""
        self.lastFocusedDate = "1970-01-01"
        self.lastFocusedMinutes = 0
    }
}
