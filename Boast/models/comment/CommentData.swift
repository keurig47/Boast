//
//  CommentData.swift
//  Boast
//
//  Created by David Keimig on 9/13/20.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct CommentData: Identifiable {
    var id: String
    var text: String
    var displayName: String?
    var createTime: Timestamp?
    var totalReplies: Int?
    var likes: Int?
}

