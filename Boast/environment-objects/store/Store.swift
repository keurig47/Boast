//
//  Store.swift
//  Boast
//
//  Created by David Keimig on 9/13/20.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class Store: ObservableObject {
    @Published var editorUrl = ""
    @Published var currentUser: User?
    @Published var feed: [PostData] = []
    @Published var activity: [ActivityData] = []
    @Published var isLight: Bool = false
    var handle: AuthStateDidChangeListenerHandle?
    var currentToken: String?

    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.registerToken(notification:)),
            name: Notification.Name("FCMToken"),
            object: nil
        )
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            self.currentUser = user
            if (self.currentUser != nil) {
                self.fetchFeed()
                self.fetchActivity()
                if self.currentToken != nil {
                    self.uploadToken()
                }
            }
        }
    }
    
    func uploadToken() {
        let db = Firestore.firestore()
        let tokenRef = db
        .collection("tokens")
        .document(self.currentUser!.uid)
        tokenRef.setData([
            "token": self.currentToken as Any
        ])
    }
    
    @objc
    func registerToken(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        if let fcmToken = userInfo["token"] as? String {
            self.currentToken = fcmToken
            if self.currentUser != nil {
                self.uploadToken()
            }
        }
    }
    
    func fetchActivity() {
        let db = Firestore.firestore()
        db
        .collection("activity")
        .document(self.currentUser!.uid)
        .collection("messages")
        .order(by: "timestamp", descending: true)
        .addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            self.activity = documents.map { document -> ActivityData in
                let data = document.data()
                let id = document.documentID
                return ActivityData(
                    id: id,
                    fromUid: data["fromUid"] as! String,
                    body: data["body"] as! String,
                    title: data["title"] as? String,
                    type: data["type"] as! String,
                    timestamp: data["timestamp"] as! Timestamp
                )
            }
        }
    }

    func fetchFeed() {
        print("FETCHING FEED")
        let db = Firestore.firestore()
        db
        .collection("feed")
        .document(self.currentUser!.uid)
        .collection("posts")
        .order(by: "createTime", descending: true)
        .addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            self.feed = documents.map { document -> PostData in
                let data = document.data()
                let id = document.documentID
                let author = data["author"] as! String
                let caption = data["caption"] as! String
                let editorValue = data["editorValue"] as! String
                let displayName = data["displayName"] as! String
                let mention = data["mention"] as! String
                let likes = data["likes"] as! Int
                let roles = data["roles"] as! [String : String]
                let syntax = data["syntax"] as! String
                let theme = data["theme"] as! String
                let createTime = data["createTime"] as! Timestamp
                return PostData(id: id, author: author, caption: caption, editorValue: editorValue, displayName: displayName, likes: likes, mention: mention, roles: roles, syntax: syntax, theme: theme, createTime: createTime)
            }
        }
    }

    deinit {
        if handle != nil {
            Auth.auth().removeStateDidChangeListener(handle!)
        }
    }
}
