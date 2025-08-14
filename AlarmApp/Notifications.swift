//
//  Notifications.swift
//  AlarmApp
//
//  Created by Adheesh Bhat on 7/22/25.
//

import UserNotifications

func requestNotificationPermission() {
    let center = UNUserNotificationCenter.current()
    center.delegate = NotificationDelegate.shared
    center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
        if granted {
            print("Permission granted")
        } else {
            print("Permission denied")
        }
    }
}

//Used to allow notifications to pop up even if app is running in the foreground
class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationDelegate()

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler:
                                @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
}


func setAlarm(dateAndTime: Date, title: String, description: String, repeat_setting: String, uniqueDate: Date, soundType: String) {
    //check if reminder already exists
    //if reminder does not exist,
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = description
    //content.sound = UNNotificationSound.default
    if soundType == "Alert" {
        content.sound = UNNotificationSound(named: UNNotificationSoundName("notification_alert.wav"))
    } else {
        content.sound = UNNotificationSound(named: UNNotificationSoundName("chord_iphone.WAV"))

    }
    var shouldRepeat: Bool = false
    if repeat_setting != "None" {
        shouldRepeat = true
    }
    let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: dateAndTime)
    
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: shouldRepeat)
    let request = UNNotificationRequest(identifier: createUniqueIDFromDate(date: uniqueDate), content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
            print("Error adding notification: \(error)")
        } else {
            print("Successfully added notification for \(dateAndTime)")
        }
    }
}
