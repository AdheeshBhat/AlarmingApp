//
//  Firebase.swift
//  AlarmApp
//
//  Created by Adheesh Bhat on 9/7/25.
//

import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

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

    // Create or update a reminder
    func setReminder(userID: String, reminder: ReminderData) {
        if let currentUser = Auth.auth().currentUser {
            do {
                try db.collection("users").document(currentUser.uid).collection("reminders").document(getExactCurrentDateString()).setData(from: reminder)
                
            } catch {
                print("Failed setReminder")
            }
        }

        
    }

    // Fetch a reminder
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
        if let currentUser = Auth.auth().currentUser {

                db.collection("users").document(currentUser.uid).collection("reminders").getDocuments { querySnapshot, error in
                    if let documents = querySnapshot?.documents, !documents.isEmpty {
                        print("Fetched reminders for user")
                        var remindersDict: [Date: ReminderData] = [:]
                        for doc in documents {
                            let data = doc.data()
                            //make a separate variable for repeatSettings + all other fields) and then pass them all in
                            remindersDict[CreateExactDateFromText(dateString: doc.documentID)] = ReminderData(ID: data["ID"], date: data["date"], title: data["title"], description: data["title"], repeatSettings: data["repeatSettings"], priority: data["priority"], isComplete: data["isComplete"], author: data["author"], isLocked: data["isLocked"])
                        }
                        completion(remindersDict)
                    } else {
                        print("Reminders for user does not exist")
                        completion(nil)
                    }}
                
            
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
            do {
                try db.collection("users").document(currentUser.uid).collection("reminders").document(dateCreated).updateData(fields)
            } catch {
                print("Failed updateReminderFields")
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
