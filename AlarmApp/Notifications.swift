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


func setAlarm(dateAndTime: Date, title: String, description: String, repeat_type: String, repeat_until_date: String, repeatIntervals: CustomRepeatType?, reminderID: String, soundType: String) {
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

    let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: dateAndTime)
    
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: shouldRepeat)
    let request = UNNotificationRequest(identifier: createUniqueIDFromDate(date: createExactDateFromString(dateString: reminderID)), content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
            print("Error adding notification: \(error)")
        } else {
            print("Successfully added notification for \(dateAndTime)")
        }
    }
}

//func setAlarm(dateAndTime: Date, title: String, description: String, repeat_type: String, repeat_until_date: String, repeatIntervals: CustomRepeatType?, reminderID: String, soundType: String) {
//    let content = UNMutableNotificationContent()
//    content.title = title
//    content.body = description
//    content.sound = soundType == "Alert"
//        ? UNNotificationSound(named: UNNotificationSoundName("notification_alert.wav"))
//        : UNNotificationSound(named: UNNotificationSoundName("chord_iphone.WAV"))
//
//    var triggers: [Date] = []
//    
//    let calendar = Calendar.current
//    let startDate = dateAndTime
//    
//    // Parse repeat_until_date
//    var endDate: Date? = nil
//    if repeat_until_date != "Forever" && !repeat_until_date.isEmpty {
//        let fmt = DateFormatter()
//        fmt.dateStyle = .medium
//        endDate = fmt.date(from: repeat_until_date)
//    }
//
//    // Helper to add dates for repeats
//    func addRepeatingDates(interval: DateComponents) {
//        var nextDate = startDate
//        while endDate == nil || nextDate <= endDate! {
//            triggers.append(nextDate)
//            if let d = calendar.date(byAdding: interval, to: nextDate) {
//                nextDate = d
//            } else {
//                break
//            }
//        }
//    }
//
//    switch repeat_type {
//    case "None":
//        triggers.append(startDate)
//        
//    case "Daily":
//        addRepeatingDates(interval: DateComponents(day: 1))
//        
//    case "Weekly":
//        addRepeatingDates(interval: DateComponents(weekOfYear: 1))
//        
//    case "Custom":
//        if let repeatIntervals = repeatIntervals, let daysString = repeatIntervals.days {
//            let weekdays = daysString.split(separator: ",").compactMap { weekdayFromString(String($0)) }
//            for weekday in weekdays {
//                var nextDate = startDate
//                while endDate == nil || nextDate <= endDate! {
//                    let comps = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: nextDate)
//                    if let dayDate = calendar.nextDate(after: nextDate, matching: DateComponents(hour: calendar.component(.hour, from: startDate), minute: calendar.component(.minute, from: startDate), weekday: weekday), matchingPolicy: .nextTime) {
//                        if endDate == nil || dayDate <= endDate! {
//                            triggers.append(dayDate)
//                            nextDate = calendar.date(byAdding: .weekOfYear, value: 1, to: dayDate) ?? dayDate.addingTimeInterval(604800)
//                        } else {
//                            break
//                        }
//                    } else {
//                        break
//                    }
//                }
//            }
//        }
//        
//    default:
//        triggers.append(startDate)
//    }
//
//    // Schedule notifications
//    for (index, triggerDate) in triggers.enumerated() {
//        let comps = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate)
//        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
//        let identifier = "\(createUniqueIDFromDate(date: createExactDateFromString(dateString: reminderID)))-\(index)"
//        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
//        UNUserNotificationCenter.current().add(request) { error in
//            if let error = error {
//                print("Error adding notification: \(error)")
//            } else {
//                print("Scheduled notification \(identifier) for \(triggerDate)")
//            }
//        }
//    }
//}

func cancelAlarm(reminderID: String) {
    let identifier = createUniqueIDFromDate(date: createExactDateFromString(dateString: reminderID))
    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    print("Cancelled notification with ID: \(identifier)")
}
