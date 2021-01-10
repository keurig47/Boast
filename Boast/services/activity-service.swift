//
//  activity.swift
//  Boast
//
//  Created by David Keimig on 9/22/20.
//

import Foundation
import Firebase
import FirebaseFirestore

func removeActivityItems(activityItems: [ActivityData], offsets: IndexSet, uid: String?) {
    if uid != nil {
        let db = Firestore.firestore()
        let batch = db.batch()
        for activityId in offsets {
            let activityItem = activityItems[activityId]
            let item = db
                .collection("activity").document(uid!)
                .collection("messages").document(activityItem.id)
            batch
                .deleteDocument(item)
        }
        batch.commit() { err in
            if let err = err {
                print("Error writing batch \(err)")
            } else {
                print("Batch write succeeded.")
            }
        }
    }
}
