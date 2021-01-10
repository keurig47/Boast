//
//  Post.swift
//  Boast
//
//  Created by David Keimig on 9/13/20.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseFirestore

struct Post: View {
    var data: PostData
    var user: String?
    var isPlaying: Bool?
    let df = DateFormatter()
    @State var isCodeView: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            PostHeader(data: data)
            NavigationLink(destination: PostView(data: data), isActive: self.$isCodeView) {
                EmptyView()
            }
            CodeViewer(defaultValue: data.editorValue, isPlaying: self.isPlaying ?? false)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 400, idealHeight: 400, maxHeight: 400, alignment: .center)
                .clipped()
                .onTapGesture {
                    self.isCodeView = true
                }
            PostFooter(data: data, user: self.user)
            .padding([.leading, .trailing], 16)
        }
        .onAppear {
            self.df.dateFormat = "yyyy-MM-dd hh:mm:ss"
        }
        .padding([.top], 12)
    }
}

struct PostHeader: View {
    var data: PostData
    @State var showActions: Bool = false
    @EnvironmentObject var authState: AuthStateProvider
    
    var body: some View {
        HStack(alignment: .top) {
            VStack {
                AvatarIcon(uid: self.authState.currentUser?.uid, size: .small)
                Spacer()
            }
            VStack(alignment: .leading) {
                Spacer()
                Text(data.displayName)
                    .font(.subheadline)
                    .fontWeight(.bold)
                Text(data.syntax.capitalized)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
            }
            Spacer()
            VStack {
                Spacer()
                Button(action: {
                    self.showActions = true
                }, label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.primary)
                })
                Spacer()
            }
        }
        .actionSheet(isPresented: self.$showActions) {
            ActionSheet(title: Text("Post Options"), buttons: [
                .default(Text("Report")),
                .cancel()
            ])
        }
        .padding([.leading, .trailing], 16)
        .padding(.top, 10)
    }
}

struct PostFooter: View {
    var data: PostData
    var user: String?
    @State var isCommentsActive: Bool = false
    @State var showShare: Bool = false
    @EnvironmentObject var authState: AuthStateProvider
    @ObservedObject var likelistener: LikeListener
    let df = DateFormatter()
    
    init(data: PostData, user: String?) {
        self.df.dateFormat = "yyyy-MM-dd hh:mm:ss"
        self.data = data
        self.user = user
        if user != nil {
            self.likelistener = LikeListener("posts/\(data.author)/posts/\(data.id)/likes/\(user!)")
        } else {
            self.likelistener = LikeListener(nil)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            NavigationLink(destination: CommentsView(data: data, author: authState.currentUser?.uid ?? ""), isActive: $isCommentsActive) {
                EmptyView()
            }
            HStack {
                Button(action: {
                    onLike(id: data.id, user: self.user, isLiked: self.likelistener.isLiked)
                }, label: {
                    Image(systemName: self.likelistener.isLiked ? "heart.fill" : "heart")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                })
                .foregroundColor(self.likelistener.isLiked ? .pink : .primary)
                .padding([.trailing], 8)
                Button(action: {
                    self.isCommentsActive = true
                }, label: {
                    Image(systemName: "message")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                })
                .foregroundColor(.primary)
                .padding([.trailing], 8)
                Button(action: {
                    self.showShare = true
                }, label: {
                    Image(systemName: "square.and.arrow.up")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                })
                .foregroundColor(.primary)
                Spacer()
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Image(systemName: "bookmark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                })
                .foregroundColor(.primary)
            }
            .padding([.top, .bottom], 8)
            Text(String(format: "%0.1d likes", data.likes))
                .font(.subheadline)
                .fontWeight(.bold)
                .padding([.bottom], 1)
            Text(data.caption)
                .font(.subheadline)
            Text(Date().timeIntervalSince(data.createTime.dateValue()).stringFromTimeInterval())
                .font(.caption)
                .foregroundColor(.secondary)
                .padding([.top], 1)
        }
        .background(self.showShare ? AnyView(ShareViewController(showShare: self.$showShare, copyString: data.editorValue)) : AnyView(EmptyView()))
    }
}

//struct Post_Previews: PreviewProvider {
//    static var previews: some View {
//        Post()
//    }
//}
