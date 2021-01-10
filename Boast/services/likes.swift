//
//  likes.swift
//  Boast
//
//  Created by David Keimig on 10/2/20.
//

import Foundation
import Firebase
import FirebaseFirestore

func onLike(id: String, user: String?, isLiked: Bool) {
    let db = Firestore.firestore()
    let batch = db.batch()
    let increment = FieldValue.increment(Int64(isLiked ? -1 : 1))
    if user != nil {
        let likeRef = db.collection("posts").document(user!).collection("posts").document(id)
            .collection("likes").document(user!)
        let counterRef = db.collection("posts").document(user!).collection("posts").document(id)
            .collection("_counter_shards_").document()
        if isLiked {
            batch
                .deleteDocument(likeRef)
                .setData(["likes": increment], forDocument: counterRef)
        } else {
            batch
                .setData([:], forDocument: likeRef)
                .setData(["likes": increment], forDocument: counterRef)
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
