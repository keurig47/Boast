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

class CommentListener: ObservableObject {
    var handler: ListenerRegistration?
    @Published var comments: [CommentData] = []
    
    init(id: String) {
        let db = Firestore.firestore()
        self.handler =
            db.collection("comments")
            .document(id)
            .collection("comments")
            .order(by: "createTime", descending: true)
            .addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                self.comments = documents.map { document -> CommentData in
                    let data = document.data()
                    let id = document.documentID
                    let text = data["text"] as! String
                    let totalReplies = data["totalReplies"] as! Int
                    if data["displayName"] == nil {
                        return CommentData(
                            id: id,
                            text: text,
                            totalReplies: totalReplies
                        )
                    }
                    let displayName = data["displayName"] as! String
                    let createTime = data["createTime"] as! Timestamp
                    let likes = data["likes"] as! Int
                    return CommentData(
                        id: id,
                        text: text,
                        displayName: displayName,
                        createTime: createTime,
                        totalReplies: totalReplies,
                        likes: likes
                    )
                }
            }
    }
    
    deinit {
        if self.handler != nil {
            self.handler!.remove();
            print("Removing listener")
        }
    }
}
