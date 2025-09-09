//
//  Firebase.swift
//  AlarmApp
//
//  Created by Adheesh Bhat on 9/7/25.
//

import FirebaseCore
import FirebaseFirestore

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
    init() {
        FirebaseApp.configure()
    }
    
    private let db = Firestore.firestore()

    // Create or update a reminder
    func setReminder(userID: String, reminder: ReminderData) {
        do {
            try db.collection("reminder").document(userID).setData(from: reminder)
            
        } catch {
            print("Failed setReminder")
        }
    }

    // Fetch a reminder
    func getReminder(userID: String, completion: @escaping (Result<ReminderData, Error>) -> Void) {
        let docRef = db.collection("reminder").document(userID)
        docRef.getDocument { document, error in
            if let document = document, document.exists {
                if let reminder = try? document.data(as: ReminderData.self) {
                    completion(.success(reminder))
                } else {
                    completion(.failure(NSError(domain: "FirestoreManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode reminder"])))
                }
            } else {
                completion(.failure(error ?? NSError(domain: "FirestoreManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document does not exist"])))
            }
        }
    }

    // Update specific fields of a reminder
    func updateReminderFields(userID: String, fields: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("reminder").document(userID).updateData(fields) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
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

    // Delete a reminder document
    func deleteReminderDocument(userID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("reminder").document(userID).delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
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

    func testGetReminder() {
        firestoreManager.getReminder(userID: "user123") { result in
            switch result {
            case .success(let reminder):
                print("Fetched reminder: \(reminder)")
            case .failure(let error):
                print("Error fetching reminder: \(error)")
            }
        }
    }

    func testUpdateReminderFields() {
        firestoreManager.updateReminderFields(userID: "user123", fields: ["title": "test title"]) { result in
            switch result {
            case .success:
                print("Successfully updated fields")
            case .failure(let error):
                print("Error updating fields: \(error)")
            }
        }
    }

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

    func testDeleteReminderDocument() {
        firestoreManager.deleteReminderDocument(userID: "user123") { result in
            switch result {
            case .success:
                print("Successfully deleted reminder document")
            case .failure(let error):
                print("Error deleting reminder: \(error)")
            }
        }
    }
    
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
