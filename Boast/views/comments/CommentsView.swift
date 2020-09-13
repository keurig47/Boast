//
//  CommentsView.swift
//  Boast
//
//  Created by David Keimig on 9/12/20.
//

import SwiftUI

struct CommentsView: View {
    var data: PostData
    
    var body: some View {
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
            .padding(8)
            Divider()
            VStack {
                Text("Hi!")
            }
            .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            CommentBar()
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
