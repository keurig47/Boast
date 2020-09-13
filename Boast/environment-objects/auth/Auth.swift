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
    var handle: AuthStateDidChangeListenerHandle?
    
    init() {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            self.showLogin = (user == nil)
            self.currentUser = user
        }
    }
    
    deinit {
        if handle != nil {
            Auth.auth().removeStateDidChangeListener(handle!)
        }
    }
}
