//
//  PostData.swift
//  Boast
//
//  Created by David Keimig on 9/13/20.
//

import SwiftUI
import FirebaseFirestore

struct PostData: Identifiable {
    var id: String
    var author: String
    var caption: String
    var editorValue: String
    var displayName: String
    var likes: Int
    var mention: String
    var roles: [String : String]
    var syntax: String
    var theme: String
    var createTime: Timestamp
}
