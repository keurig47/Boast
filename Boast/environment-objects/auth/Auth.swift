//
//  Auth.swift
//  Boast
//
//  Created by David Keimig on 9/13/20.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class AuthStateProvider: ObservableObject {
    @Published var showLogin: Bool = false
    @Published var currentUser: User?
    @Published var userData: UserData?
    var handle: AuthStateDidChangeListenerHandle?
    var viewingUser: String?
    
    init() {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            self.showLogin = (user == nil)
            self.currentUser = user
            self.fetchCurrentUser(uid: self.currentUser?.uid)
        }
    }
    
    func fetchCurrentUser(uid: String?) {
        if currentUser != nil {
            let db = Firestore.firestore()
            db
            .collection("users")
            .document(self.currentUser!.uid)
            .addSnapshotListener { (document, error) in
                do {
                    let decoder = JSONDecoder()
                    print("FETCHING", self.currentUser!.uid)
                    let data = document!.data() as Any
                    let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                    self.userData = try decoder.decode(UserData.self, from: jsonData)
                } catch {
                    print("Serialization error", error)
                }
            }
        }
    }
    
    func setUser(user: ElasticUser?) {
        if viewingUser != user?.id {
            self.kill()
            if user != nil {
                self.fetchCurrentUser(uid: user?.id)
                self.viewingUser = user?.id
            } else {
                self.fetchCurrentUser(uid: self.currentUser?.uid)
                self.viewingUser = self.currentUser?.uid
            }
        }
    }
    
    func kill() {
        if handle != nil {
            Auth.auth().removeStateDidChangeListener(handle!)
        }
    }
    
    deinit {
        self.kill()
    }
}
