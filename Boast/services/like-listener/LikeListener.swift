//
//  LikeListener.swift
//  Boast
//
//  Created by David Keimig on 9/13/20.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseFirestore

class LikeListener: ObservableObject {
    var handler: ListenerRegistration?
    @Published var isLiked: Bool = false
    
    init(id: String, user: String?) {
        if user != nil {
            let db = Firestore.firestore()
            let doc = db.collection("posts").document(id)
                .collection("likes").document(user!)
            self.handler = doc.addSnapshotListener { (querySnapshot, error) in
                guard let exists = querySnapshot?.exists else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                if exists {
                    self.isLiked = true
                } else {
                    self.isLiked = false
                }
            }
        }
    }
    
    deinit {
        if self.handler != nil {
            self.handler!.remove();
        }
    }
}
