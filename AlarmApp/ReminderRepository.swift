//
//  ReminderRepository.swift
//  AlarmApp
//
//  Created by Adheesh Bhat on 9/7/25.
//

//import Foundation
//import FirebaseFirestore
//
//
//class ReminderRepository {
//    private let db = Firestore.firestore()
//    
//    func addReminder(_ reminder: ReminderData, userID: String, completion: ((Error?) -> Void)? = nil) {
//        let data: [String: Any] = [
//            "ID": reminder.ID,
//            "title": reminder.title,
//            "date": reminder.date,
//            "isComplete": reminder.isComplete
//        ]
//        
//        db.collection("users")
//            .document(userID)
//            .collection("reminders")
//            .document(String(reminder.ID))
//            .setData(data) { error in
//                completion?(error)
//            }
//    }
    
//    func fetchReminders(for userID: String, completion: @escaping ([ReminderData]) -> Void) {
//        db.collection("users")
//            .document(userID)
//            .collection("reminders")
//            .getDocuments { snapshot, error in
//                if let error = error {
//                    print("Error fetching reminders: \(error)")
//                    completion([])
//                    return
//                }
//                let reminders = snapshot?.documents.compactMap { doc in
//                    let data = doc.data()
//                    return ReminderData(
//                        ID: Int(doc.documentID) ?? 0,
//                        date: (data["date"] as? Timestamp)?.dateValue() ?? Date(),
//                        title: data["title"] as? String ?? "",
//                        description: data["description"] as? String ?? "",
//                        repeatSettings: RepeatSettings(
//                            repeat_type: data["repeat_type"] as? String ?? "None",
//                            repeat_until_date: data["repeat_until_date"] as? String ?? ""
//                        ),
//                        priority: data["priority"] as? String ?? "Low",
//                        isComplete: data["isComplete"] as? Bool ?? false,
//                        author: data["author"] as? String ?? "user",
//                        isLocked: data["isLocked"] as? Bool ?? false
//                    )
//                } ?? []
//                completion(reminders)
//            }
//    }
//}
