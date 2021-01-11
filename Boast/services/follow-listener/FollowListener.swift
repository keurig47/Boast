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

enum FollowerStatus: String {
    case requested = "requested"
    case follower = "follower"
    case notfollowing = "notfollowing"
}

class FollowListener: ObservableObject {
    var user: String?
    var follower: String?
    var followingHandler: ListenerRegistration?
    @Published var isFollowing: Bool?
    @Published var comments: [CommentData] = []
    
    init(user: String?, follower: String?) {
        if (user != nil) && (follower != nil) {
            self.user = user
            self.follower = follower
            let db = Firestore.firestore()
            self.followingHandler =
                db.collection("users")
                .document(user!)
                .collection("following")
                .document(follower!)
                .addSnapshotListener { (querySnapshot, error) in
                    self.isFollowing = (querySnapshot?.exists)!
                }
        }
    }
    
    deinit {
        if self.followingHandler != nil {
            self.followingHandler!.remove();
        }
    }
    
    func toggle() {
        if (user != nil) && (follower != nil) && (self.isFollowing != nil) {
            let db = Firestore.firestore()
            let followingRef = db.collection("users").document(user!)
                .collection("following").document(follower!)
            if self.isFollowing! {
                followingRef.delete()
            } else {
                followingRef.setData([:])
            }
        }
    }
}
