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
    
    init(_ path: String?) {
        if path != nil {
            let db = Firestore.firestore()
            let doc = db.document(path!)
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
