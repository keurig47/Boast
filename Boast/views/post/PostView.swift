//
//  PostView.swift
//  Boast
//
//  Created by David Keimig on 9/13/20.
//

import SwiftUI

struct PostView: View {
    var data: PostData
    
    var body: some View {
        VStack(alignment: .leading) {
            CodeEditor(
                defaultValue: data.editorValue
            )
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
