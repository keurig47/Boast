//
//  PostEditor.swift
//  Boast
//
//  Created by David Keimig on 9/2/20.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

struct PostEditor: View {
    @Binding var showEditor: Bool
    @State var caption: String = ""
    @State var mention: String = ""
    @EnvironmentObject var editorState: EditorState
    @EnvironmentObject var authState: AuthStateProvider
    
    var body: some View {
        List {
            ZStack(alignment: .leading) {
                TextEditor(text: $caption)
                if caption.isEmpty {
                    Text("Add a caption...")
                        .opacity(0.3)
                }
            }
            TextField("Mention People", text: $mention)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                let defaults = UserDefaults.standard
                let theme: String = defaults.string(forKey: Constants.defaultsKey.theme) ?? ""
                let syntax: String = defaults.string(forKey: Constants.defaultsKey.syntax) ?? ""
    
                Button(action: {
                    let db = Firestore.firestore()
                    db.collection("posts").addDocument(data: [
                        "editorValue": editorState.editorValue,
                        "theme": theme,
                        "syntax": syntax,
                        "caption": caption,
                        "mention": mention,
                        "author": authState.currentUser?.uid ?? "",
                        "roles": [
                            authState.currentUser?.uid: "owner"
                        ]
                    ]) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
                        }
                        self.showEditor = false
                    }
                }, label: {
                    Text("Share")
                })
            }
            ToolbarItem(placement: .principal) {
                Text("New Post")
            }
        }
    }
}

struct PostEditor_Previews: PreviewProvider {
    static var previews: some View {
        PostEditor(showEditor: .constant(true))
    }
}
