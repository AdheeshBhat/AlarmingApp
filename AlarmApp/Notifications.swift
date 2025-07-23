//
//  Notifications.swift
//  AlarmApp
//
//  Created by Adheesh Bhat on 7/22/25.
//

import UserNotifications

func requestNotificationPermission() {
    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
        if granted {
            print("Permission granted")
        } else {
            print("Permission denied")
        }
    }
}


func setAlarm(time: Date, title: String, description: String, repeat_setting: String, uniqueDate: Date) {
    //check if reminder already exists
    //if reminder does not exist,
    let calendar = Calendar.current
    let components = calendar.dateComponents([.hour, .minute], from: Date.now.addingTimeInterval(10))
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = description
    content.sound = UNNotificationSound.default
    var shouldRepeat: Bool = false
    if repeat_setting != "None" {
        shouldRepeat = true
    }
    let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
    let request = UNNotificationRequest(identifier: createUniqueIDFromDate(date: uniqueDate), content: content, trigger: trigger)
    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
            print("Error adding notification: \(error)")
        } else {
            print("Successfully adding notification for time" + timeAsString(Date.now.addingTimeInterval(10)))
        }
    }
}
