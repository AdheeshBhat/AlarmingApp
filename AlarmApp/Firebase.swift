//
//  Firebase.swift
//  AlarmApp
//
//  Created by Adheesh Bhat on 9/7/25.
//

import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import SwiftUI

//struct Reminder: Codable {
//    var ID: Int
//    var author: String
//    var date: Date
//    var description: String
//    var isComplete: Bool
//    var isLocked: Bool
//    var priority: String
//    //var repeatSettings: RepeatSettings
//    var title: String
//}

class FirestoreManager {

    //READING FROM THE DATABASE
    private let db = Firestore.firestore()
        
    func saveUserData(userId: String, data: [String: Any], completion: @escaping (Error?) -> Void) {
        if let currentUser = Auth.auth().currentUser {
            db.collection("users").document(currentUser.uid).setData(data) { error in
                completion(error)
            }
        }
        
    }

    // Create a reminder
    func setReminder(reminderID: String, reminder: ReminderData) {
        if let currentUser = Auth.auth().currentUser {
            do {
                //try db.collection("users").document(currentUser.uid).collection("reminders").document(getExactStringFromCurrentDate()).setData(from: reminder)
                try db.collection("users").document(currentUser.uid).collection("reminders").document(reminderID).setData(from: reminder)
                
            } catch {
                print("Failed setReminder")
            }
        }

        
    }

    // Fetch a reminder
    
    //GET RID OF USERID
    func getReminder(userID: String, dateCreated: String, completion: @escaping (DocumentSnapshot?) -> Void) {
        if let currentUser = Auth.auth().currentUser {
            do {
                db.collection("users").document(currentUser.uid).collection("reminders").document(dateCreated).getDocument { document, error in
                    if let document = document, document.exists {
                        print("Fetched reminder")
                        completion(document)
                    } else {
                        print("Reminder does not exist")
                        completion(nil)
                    }}
                
            }
        }
    }
    

    func getRemindersForUser(completion: @escaping ([Date: ReminderData]?) -> Void) {
        // ensures that the user is logged in
        guard let currentUser = Auth.auth().currentUser else {
            DispatchQueue.main.async { completion(nil) }
            return
        }

        db.collection("users")
          .document(currentUser.uid)
          .collection("reminders")
          .getDocuments { querySnapshot, error in
              // if Firestore query fails
              if let error = error {
                  print("Error fetching reminders for user: \(error)")
                  DispatchQueue.main.async { completion(nil) }
                  return
              }
              //case where no documents exist
              guard let documents = querySnapshot?.documents else {
                  print("Reminders for user does not exist")
                  DispatchQueue.main.async { completion([:]) } // empty dict
                  return
              }

              var remindersDict: [Date: ReminderData] = [:]
              
              //loops through every reminder document
              for doc in documents {
                  let data = doc.data()

                  // ID
                  let id: Int = {
                      if let v = data["ID"] as? Int { return v }
                      return 0
                  }()

                  let title = data["title"] as? String ?? ""
                  let description = data["description"] as? String ?? ""
                  let priority = data["priority"] as? String ?? "Low"
                  let author = data["author"] as? String ?? "user"

                  let isComplete = data["isComplete"] as? Bool ?? false
                  let isLocked = data["isLocked"] as? Bool ?? false

                  let dateFromField: Date? = {
                      if let ts = data["date"] as? Timestamp {
                          return ts.dateValue()
                      }
                      return nil
                  }()

                  // repeatSettings
                  let repeatSettings: RepeatSettings = {
                      if let rsMap = data["repeatSettings"] as? [String: Any] {
                          let repeatType = rsMap["repeat_type"] as? String ?? (data["repeat_type"] as? String ?? "None")
                          let repeatUntil = rsMap["repeat_until_date"] as? String ?? (data["repeat_until_date"] as? String ?? "")
                          return RepeatSettings(repeat_type: repeatType, repeat_until_date: repeatUntil)
                      } else {
                          let repeatType = data["repeat_type"] as? String ?? "None"
                          let repeatUntil = data["repeat_until_date"] as? String ?? ""
                          return RepeatSettings(repeat_type: repeatType, repeat_until_date: repeatUntil)
                      }
                  }()

                  // Build ReminderData (matches your initializer)
                  let reminder = ReminderData(
                      ID: id,
                      date: dateFromField ?? Date(),
                      title: title,
                      description: description,
                      repeatSettings: repeatSettings,
                      priority: priority,
                      isComplete: isComplete,
                      author: author,
                      isLocked: isLocked
                  )

                  // Key by a Date that the rest of your app expects. Use the doc ID -> Date helper so it matches your previous mock-keying.
                  if let validDate = dateFromField {
                      remindersDict[validDate] = reminder
                  } else {
                      print("Warning: Reminder missing date field, using current Date() as fallback")
                          remindersDict[Date()] = reminder
                  }
//                  let keyDate = createExactDateFromString(dateString: doc.documentID)
//                  remindersDict[keyDate] = reminder
              }

              // return on main thread
              DispatchQueue.main.async { completion(remindersDict) }
          }
    }
    
//    func getReminder(userID: String, dateCreated: String, completion: @escaping (Result<ReminderData, Error>) -> Void) {
//        db.collection("users").document(userID).collection("reminders").document(dateCreated).getDocument { document, error in
//            if let document = document, document.exists {
//                if let reminder = try? document.data(as: ReminderData.self) {
//                    completion(.success(reminder))
//                } else {
//                    completion(.failure(NSError(domain: "FirestoreManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode reminder"])))
//                }
//            } else {
//                completion(.failure(error ?? NSError(domain: "FirestoreManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document does not exist"])))
//            }
//        }
//    }

    // Update specific fields of a reminder
    func updateReminderFields(dateCreated: String, fields: [String: Any]) {
        if let currentUser = Auth.auth().currentUser {
            db.collection("users").document(currentUser.uid).collection("reminders").document(dateCreated).updateData(fields) { error in
                if let error = error {
                    print("Failed to update reminder fields: \(error.localizedDescription)")
                } else {
                    print("Successfully updated reminder fields")
                }
            }
        }
    }

    // Delete a specific field from a reminder
    func deleteReminderField(userID: String, field: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("reminder").document(userID).updateData([field: FieldValue.delete()]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    //Delete a reminder document (a whole reminder, with all the fields)
    func deleteReminder(userID: String, dateCreated: String, completion: ((Error?) -> Void)? = nil) {
        if let currentUser = Auth.auth().currentUser {
            db.collection("users").document(currentUser.uid).collection("reminders").document(dateCreated).delete { error in
                if let error = error {
                    print("Error deleting reminder: \(error)")
                } else {
                    print("Reminder deleted successfully")
                }
                completion?(error)
            }
        }
    }

//    // Delete a reminder document
//    func deleteReminderDocument(userID: String, completion: @escaping (Result<Void, Error>) -> Void) {
//        db.collection("reminder").document(userID).delete { error in
//            if let error = error {
//                completion(.failure(error))
//            } else {
//                completion(.success(()))
//            }
//        }
//    }
    
    // Delete a reminder collection
    //Can't delete the actual collection - instead deletes everything inside (all documents and fields)
    func deleteReminderCollection(collection: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let collectionRef = db.collection(collection)
        
        collectionRef.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion(.success(())) // nothing to delete
                return
            }
            
            let batch = self.db.batch()
            
            for document in documents {
                batch.deleteDocument(document.reference)
            }
            
            batch.commit { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }
}


class ReminderViewModel: ObservableObject {
    private let firestoreManager = FirestoreManager()
    
//    func addTestReminder() {
//        let reminder = ReminderData(
//            ID: 1,
//            author: "Yousif",
//            date: Date(),
//            description: "description",
//            repeatSettings:
//            isComplete: true,
//            isLocked: true,
//            priority: "Low",
//            title: "Test Reminder"
//        )
//        firestoreManager.setReminder(userID: "user123", reminder: reminder) { result in
//            print(result)
//        }
//    }

//    func testGetReminder() {
//        firestoreManager.getReminder(userID: "user123") { result in
//            switch result {
//            case .success(let reminder):
//                print("Fetched reminder: \(reminder)")
//            case .failure(let error):
//                print("Error fetching reminder: \(error)")
//            }
//        }
//    }

//    func testUpdateReminderFields() {
//        firestoreManager.updateReminderFields(userID: "user123", fields: ["title": "test title"]) { result in
//            switch result {
//            case .success:
//                print("Successfully updated fields")
//            case .failure(let error):
//                print("Error updating fields: \(error)")
//            }
//        }
//    }

    func testDeleteReminderField() {
        firestoreManager.deleteReminderField(userID: "user123", field: "newField") { result in
            switch result {
            case .success:
                print("Successfully deleted field 'priority'")
            case .failure(let error):
                print("Error deleting field: \(error)")
            }
        }
    }
    

//    func testDeleteReminderDocument() {
//        firestoreManager.deleteReminderDocument(userID: "user123") { result in
//            switch result {
//            case .success:
//                print("Successfully deleted reminder document")
//            case .failure(let error):
//                print("Error deleting reminder: \(error)")
//            }
//        }
//    }
    
    //Can't delete the actual collection - instead deletes everything inside (all documents and fields)
    func testDeleteReminderCollection() {
        firestoreManager.deleteReminderCollection(collection: "testDeleteCollection") { result in
            switch result {
            case .success:
                print("Successfully deleted reminder collection")
            case .failure(let error):
                print("Error deleting reminder: \(error)")
            }
        }
    }
}

struct TestRemindersView: View {
    @State private var reminders: [Date: ReminderData] = [:]
    private let firestoreManager = FirestoreManager()
    
    var body: some View {
        VStack {
            Text("Reminders Test")
                .font(.title)
            
            List {
                ForEach(reminders.keys.sorted(), id: \.self) { date in
                    if let reminder = reminders[date] {
                        VStack(alignment: .leading) {
                            Text(reminder.title)
                                .font(.headline)
                            Text("Date: \(reminder.date)")
                            Text("Complete: \(reminder.isComplete ? "Yes" : "No")")
                        }
                    }
                }
            }
        }
        .onAppear {
            firestoreManager.getRemindersForUser { fetchedReminders in
                if let fetchedReminders = fetchedReminders {
                    print("Fetched \(fetchedReminders.count) reminders:")
                    for (date, reminder) in fetchedReminders {
                        print("Date: \(date), Title: \(reminder.title), Complete: \(reminder.isComplete)")
                    }
                    reminders = fetchedReminders
                } else {
                    print("No reminders fetched")
                }
            }
        }
    }
}
