//
//  FollowerButton.swift
//  Boast
//
//  Created by David Keimig on 9/21/20.
//

import SwiftUI

struct FollowButton: View {
    var user: ElasticUser?
    @ObservedObject var followListener: FollowListener
    
    init(user: String?, follower: String?) {
        self.followListener = FollowListener(user: user, follower: follower)
    }
    
    func getLabel() -> String {
        if followListener.isFollowing! {
            return "Following"
        } else {
            return "Follow"
        }
    }
    
    func getColor() -> Color {
        if followListener.isFollowing! {
            return Color(UIColor.secondarySystemBackground)
        } else {
            return Color.accentColor
        }
    }
    
    func getFont() -> Color {
        if followListener.isFollowing! {
            return .primary
        } else {
            return .white
        }
    }
    
    var body: some View {
        if self.followListener.isFollowing != nil {
            Button(action: {
                self.followListener.toggle()
            }, label: {
                Text(self.getLabel())
                    .font(.caption)
                    .foregroundColor(self.getFont())
                    .frame(minWidth: 0, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: 20, idealHeight: 20, maxHeight: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .padding(5)
                    .background(self.getColor())
                    .clipShape(RoundedRectangle(cornerRadius: 3))
                    .overlay (
                        RoundedRectangle(cornerRadius: 3)
                            .stroke(Color(UIColor.separator))
                    )
            })
        } else {
            EmptyView()
        }
        
    }
}

struct FollowButton_Previews: PreviewProvider {
    static var previews: some View {
        FollowButton(user: "test", follower: "me")
    }
}
