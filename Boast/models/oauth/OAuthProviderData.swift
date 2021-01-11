//
//  ProviderData.swift
//  Boast
//
//  Created by David Keimig on 9/17/20.
//

import SwiftUI

struct OAuthProviderData: Identifiable, Codable {
    var id: String
    var uid: String?
    var email: String?
    var photoURL: String?
    
    enum CodingKeys: String, CodingKey {
        case email = "email"
        case photoURL = "photoURL"
        case uid = "uid"
        case id = "providerId"
    }
}

