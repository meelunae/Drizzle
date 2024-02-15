//
//  Helpers.swift
//  Drizzle
//
//  Created by Meelunae on 15/02/24.
//

import Foundation
import UserNotifications

func getTodayDateString() -> String {
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let dateString = formatter.string(from: date)
    return dateString
}

func requestNotificationPermissions() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
        if granted {
            print("Notification permissions granted")
        } else if let error = error {
            print("Error requesting notification permissions: \(error.localizedDescription)")
        }
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
