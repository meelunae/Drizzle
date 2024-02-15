//
//  UserHistoryViewModel.swift
//  Drizzle
//
//  Created by Meelunae on 15/02/24.
//

import SwiftUI

struct FocusDay: Codable {
    var date: String
    var studyTime: Int
    var restTime: Int
    var numberOfSessions: Int
}

class HistoryViewModel: ObservableObject {
    @Published var history: [FocusDay] = []
    var appPreferences: AppPreferences?

    init() {
        loadData()
    }

    func syncHistoryData() {
        if let appPreferences, history.first != nil {
            if history.first?.date == getTodayDateString() {
                print("I have already opened up the app today, adjusting history values to current AppStorage values")
                print(appPreferences.focusMinsToday)
                print(appPreferences.restMinsToday)
                history[0].studyTime = appPreferences.focusMinsToday
                history[0].restTime = appPreferences.restMinsToday
            } else {
                print("Have not opened the app yet for today, adding a new focus day and resetting AppStorage values")
                history.insert(FocusDay(
                    date: getTodayDateString(),
                    studyTime: 0,
                    restTime: 0,
                    numberOfSessions: 0
                ), at: 0)
                appPreferences.refreshDailyValues()
            }
        }
    }

    func loadData() {
        if let fileURL = try? FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("history.json"),
           let jsonData = try? Data(contentsOf: fileURL) {
            let decoder = JSONDecoder()
            if let decodedHistory = try? decoder.decode([FocusDay].self, from: jsonData) {
                self.history = decodedHistory
            } else {
                print("Error decoding history data")
            }
        } else {
            print("History file was deleted or changed, creating new file.")
            self.history = [FocusDay(date: getTodayDateString(), studyTime: 0, restTime: 0, numberOfSessions: 0)]
            saveData(data: history)
        }
    }

    func saveData(data: [FocusDay]) {
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(data)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                let fileURL = try FileManager.default
                    .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    .appendingPathComponent("history.json")
                try jsonString.write(to: fileURL, atomically: true, encoding: .utf8)
                print("Saved data!")
            }
        } catch {
            print("Error saving data: \(error.localizedDescription)")
        }
    }
}
