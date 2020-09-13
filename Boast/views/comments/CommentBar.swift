//
//  CommentBar.swift
//  Boast
//
//  Created by David Keimig on 9/12/20.
//

import SwiftUI

struct SizePreferenceKey: PreferenceKey {
    typealias Value = CGSize
    static var defaultValue: Value = .zero

    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}

struct CommentBar: View {
    @State var comment: String = ""
    @State var height: CGFloat = 40
    @State var textEditorSize: CGSize?
    
    var textFieldHeight: CGFloat {
        let minHeight: CGFloat = 40
        let maxHeight: CGFloat = 90
        
        if height < minHeight {
            return minHeight
        }
        
        if height > maxHeight {
            return maxHeight
        }
        
        return height
    }
    
    var body: some View {
        HStack {
            AsyncImage(url: "https://i.pinimg.com/originals/51/f6/fb/51f6fb256629fc755b8870c801092942.png")
                .padding(.top, 3.0)
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40, alignment: .top)
            HStack {
                CommentTextEditor(text: $comment, height: $height)
                Button(action: {
                    print("Posting...")
                }, label: {
                    Text("Post")
                })
            }
            .padding([.leading, .trailing], 10)
            .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: textFieldHeight, idealHeight: textFieldHeight, maxHeight: textFieldHeight, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.secondary, lineWidth: 1)
                    .opacity(0.5)
            )
        }
        .padding(10)
    }
}

struct CommentBar_Previews: PreviewProvider {
    static var previews: some View {
        CommentBar()
    }
}
