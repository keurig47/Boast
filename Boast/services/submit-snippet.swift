//
//  submit-snippet.swift
//  Boast
//
//  Created by David Keimig on 9/13/20.
//

import SwiftUI
import Foundation
import Firebase
import FirebaseFirestore

func submitSnippet(
    editorValue: String,
    theme: String,
    syntax: String,
    caption: String,
    mention: String,
    author: String,
    roles: [String?: String],
    completionHandler: @escaping (Bool) -> Void) {
    let db = Firestore.firestore()
    db.collection("posts").document(author)
    .collection("posts").addDocument(data: [
        "editorValue": editorValue,
        "theme": theme,
        "syntax": syntax,
        "caption": caption,
        "mention": mention,
        "author": author,
        "roles": roles,
    ]) { err in
        completionHandler(true)
    }
}
