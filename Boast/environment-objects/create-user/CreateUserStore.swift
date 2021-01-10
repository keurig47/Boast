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

class CreateUserStore: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var username: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var avatar: UIImage?

    init() {

    }
    
    deinit {

    }
}
