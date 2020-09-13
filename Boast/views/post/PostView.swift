//
//  PostView.swift
//  Boast
//
//  Created by David Keimig on 9/13/20.
//

import SwiftUI

struct PostView: View {
    var data: PostData
    @EnvironmentObject var editorState: EditorState
    
    var body: some View {
        VStack(alignment: .leading) {
            CodeEditor(
                defaultValue: data.editorValue,
                options: [:],
                isUserInteractionEnabled: true,
                theme: data.theme,
                syntax: data.syntax
            )
            .environmentObject(editorState)
        }
        .navigationTitle(data.displayName)
        .navigationBarTitleDisplayMode(.inline)
    }
    
}

//struct PostView_Previews: PreviewProvider {
//    static var previews: some View {
//        PostView()
//    }
//}
