//
//  CommentsView.swift
//  Boast
//
//  Created by David Keimig on 9/12/20.
//

import SwiftUI

class CommentBarState: ObservableObject {
    @Published var isActive: Bool = false
    @Published var replyId: String?
}

struct Comment: View {
    var postId: String
    var author: String?
    var comment: CommentData
    var scrollReader: ScrollViewProxy
    @ObservedObject var likelistener: LikeListener
    @ObservedObject var commentBarState: CommentBarState
    var displayName: String = "Loading..."
    var createTimestamp: String = "Loading..."
    
    init(postId: String, author: String?, comment: CommentData, scrollReader: ScrollViewProxy, commentBarState: CommentBarState) {
        self.postId = postId
        self.author = author
        self.comment = comment
        self.scrollReader = scrollReader
        self.commentBarState = commentBarState
        if (comment.createTime != nil) {
            self.createTimestamp = Date().timeIntervalSince(comment.createTime!.dateValue()).stringFromTimeInterval()
        }
        if (comment.displayName != nil) {
            self.displayName = comment.displayName!
        }
        if author != nil {
            self.likelistener = LikeListener("comments/\(postId)/comments/\(comment.id)/likes/\(author!)")
        } else {
            self.likelistener = LikeListener(nil)
        }
    }
    
    var body: some View {
        HStack {
            VStack {
                AsyncImage(url: "https://i.pinimg.com/originals/51/f6/fb/51f6fb256629fc755b8870c801092942.png")
                    .padding(.top, 3.0)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40, alignment: .top)
                Button(action: {
                    if self.author != nil {
                        likeComment(postId: postId, commentId: comment.id, author: self.author!, isLiked: self.likelistener.isLiked, replyId: nil)
                    }
                }, label: {
                    Image(systemName: self.likelistener.isLiked ? "heart.fill" : "heart")
                        .frame(width: 10, height: 10, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .foregroundColor(self.likelistener.isLiked ? .pink : .secondary)
                })
                .padding([.top], 3)
            }
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Text("\(displayName) ")
                        .font(.footnote)
                        .bold()
                    +
                    Text(comment.text)
                        .font(.footnote)
                }
                HStack {
                    Text(self.createTimestamp)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding([.top], 2)
                    if (comment.likes != nil) && (comment.likes != 0) {
                        Text("\(comment.likes!) likes")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding([.top], 2)
                    }
                    Button(action: {
                        commentBarState.replyId = comment.id
                        commentBarState.isActive = true
                        withAnimation {
                            scrollReader.scrollTo(comment.id, anchor: .top)
                        }
                    }, label: {
                        Text("Reply")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding([.top], 2)
                    })
                }
            }
        }
        .padding(5)
    }
}

struct CommentGroup: View {
    var postId: String
    var author: String?
    var comment: CommentData
    var scrollReader: ScrollViewProxy
    @ObservedObject var commentBarState: CommentBarState
    @State var isExpanded: Bool = false
    @State var replies: [CommentData]?
    
    var body: some View {
        Group {
            if comment.totalReplies == 0 {
                HStack {
                    Comment(
                        postId: postId,
                        author: author,
                        comment: comment,
                        scrollReader: scrollReader,
                        commentBarState: commentBarState
                    )
                    Spacer()
                }
                .animation(.easeIn)
            } else {
                DisclosureGroup(
                    isExpanded: $isExpanded,
                    content: {
                        Group {
                            if replies == nil {
                                ProgressView()
                            }
                            else {
                                ForEach(self.replies ?? []) { reply in
                                    HStack {
                                        Comment(postId: postId, author: author, comment: reply, scrollReader: scrollReader, commentBarState: commentBarState)
                                            .padding([.leading])
                                        Spacer()
                                    }
                                }
                            }
                        }
                    },
                    label: {
                        HStack {
                            Comment(postId: postId, author: author, comment: comment, scrollReader: scrollReader, commentBarState: commentBarState)
                            Spacer()
                            if comment.totalReplies != 0 {
                                Button(action: {
                                    self.isExpanded.toggle()
                                }, label: {
                                    Text("\(comment.totalReplies!) replies")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                })
                            }
                        }
                    }
                )
                .onChange(of: isExpanded) { value in
                    getReplies(postId: postId, replyId: comment.id) { commentData in
                        withAnimation {
                            self.replies = commentData
                        }
                    }
                }
            }
        }
    }
}

struct CommentsView: View {
    var data: PostData
    var author: String?
    @ObservedObject var commentBarState: CommentBarState = CommentBarState()
    @ObservedObject var commentListener: CommentListener
    
    init(data: PostData, author: String) {
        self.data = data
        self.author = author
        self.commentListener = CommentListener(id: data.id)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    AsyncImage(url: "https://i.pinimg.com/originals/51/f6/fb/51f6fb256629fc755b8870c801092942.png")
                        .padding(.top, 3.0)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40, alignment: .top)
                    VStack(alignment: .leading) {
                        HStack(alignment: .top) {
                            Text("\(data.displayName) ")
                                .font(.footnote)
                                .bold()
                            +
                            Text(data.caption)
                                .font(.footnote)
                        }
                        Text(Date().timeIntervalSince(data.createTime.dateValue()).stringFromTimeInterval())
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding([.top], 2)
                    }
                }
                Divider()
            }
            .padding([.leading, .trailing, .top])
            ScrollView {
                VStack(alignment: .leading) {
                    ScrollViewReader { scrollReader in
                        ForEach(self.commentListener.comments) { comment in
                            CommentGroup(
                                postId: data.id,
                                author: author,
                                comment: comment,
                                scrollReader: scrollReader,
                                commentBarState: commentBarState
                            )
                            .id(comment.id)
                        }
                    }
                }
                .padding([.leading, .trailing])
            }
            .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            CommentBar(postId: data.id, author: author, commentBarState: commentBarState)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle("Comments")
    }
}

//struct CommentsView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentsView()
//    }
//}
