//
//  comments.swift
//  Boast
//
//  Created by David Keimig on 9/13/20.
//

import SwiftUI
import Foundation
import Firebase
import FirebaseFirestore

func postComment(
    text: String,
    postId: String,
    author: String,
    roles: [String:String],
    replyId: String?,
    completionHandler: @escaping (Bool) -> Void) {
    
    let db = Firestore.firestore()
    
    if replyId != nil {
        let batch = db.batch()
        let increment = FieldValue.increment(Int64(1))
        
        let replyRef = db.collection("comments").document(postId)
            .collection("comments").document(replyId!)
            .collection("replies").document()
        
        let counterRef = db.collection("comments").document(postId)
            .collection("comments").document(replyId!)
            .collection("_counter_shards_").document()
        
        batch
            .setData([
                "text": text,
                "author": author,
                "roles": roles
            ], forDocument: replyRef)
            .setData(["totalReplies": increment], forDocument: counterRef)
        
        batch.commit() { err in
            if let err = err {
                print("Error writing batch \(err)")
            } else {
                print("Batch write succeeded.")
            }
        }
        
    } else {
        db
        .collection("comments").document(postId)
        .collection("comments").addDocument(data: [
            "text": text,
            "author": author,
            "roles": roles
        ]) { err in
            completionHandler(true)
        }
    }
}

func getReplies(postId: String, replyId: String, completionHandler: @escaping ([CommentData]) -> Void) {
    let db = Firestore.firestore()
    
    db
    .collection("comments").document(postId)
    .collection("comments").document(replyId)
    .collection("replies").getDocuments() { (querySnapshot, err) in
        let documents = querySnapshot!.documents
        let commentData = documents.map { document -> CommentData in
            let data = document.data()
            let id = document.documentID
            let text = data["text"] as! String
            if data["displayName"] == nil {
                return CommentData(
                    id: id,
                    text: text
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
                likes: likes
            )
        }
        completionHandler(commentData)
    }
}

func likeComment(postId: String, commentId: String, author: String?,
                 isLiked: Bool, replyId: String?) {
    let db = Firestore.firestore()
    let batch = db.batch()
    if (author != nil) {
        let increment = FieldValue.increment(Int64(isLiked ? -1 : 1))
        
        let likeRef = db.collection("comments").document(postId)
            .collection("comments").document(commentId)
            .collection("likes").document(author!)
        
        let counterRef = db.collection("comments").document(postId)
            .collection("comments").document(commentId)
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
