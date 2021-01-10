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
    var postId: String
    var author: String?
    @ObservedObject var commentBarState: CommentBarState
    @State var comment: String = ""
    @State var height: CGFloat = 40
    @State var disabled: Bool = false
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
        VStack {
            Divider()
            HStack {
                AsyncImage(url: "https://i.pinimg.com/originals/51/f6/fb/51f6fb256629fc755b8870c801092942.png")
                    .padding(.top, 3.0)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40, alignment: .top)
                HStack {
                    CommentTextEditor(
                        text: $comment,
                        height: $height,
                        disabled: $disabled,
                        commentBarState: commentBarState
                    )
                    Button(action: {
                        self.disabled = true
                        if author != nil {
                            postComment(
                                text: self.comment,
                                postId: postId,
                                author: self.author!,
                                roles: [
                                    self.author!: "owner"
                                ],
                                replyId: commentBarState.replyId
                            ) { succes in
                                self.disabled = false
                                self.comment = ""
                            }
                        }
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
        }
        .padding([.leading, .bottom, .trailing])
    }
}

//struct CommentBar_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentBar(postId: "", isActive: .constant(false))
//    }
//}
