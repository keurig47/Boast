//
//  AddFriendsView.swift
//  Boast
//
//  Created by David Keimig on 9/18/20.
//

import SwiftUI

struct AddFriendsView: View {
    @State var selectedIndex: Int = 0
    let tabs: [String] = ["swift", "javascript", "java", "python", "kotlin"]
    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                VStack {
                    Text("Welcome to Boast")
                        .font(.headline)
                        .padding(3)
                    Text("When you follow, people you'll see the snippets they post here.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                TabView {
                    ForEach(0 ..< tabs.count) { index in
                        VStack {
                            Spacer()
                            VStack {
//                                AvatarIcon()
//                                    .frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            }
                            Spacer()
                            Text(tabs[index])
                                .bold()
                            Text(tabs[index])
                                .font(.caption)
                                .foregroundColor(Color.secondary)
                                .bold()
                            Spacer()
                            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                                Text("Follow")
                                    .font(.caption)
                                    .bold()
                                    .padding(8)
                            })
                            .foregroundColor(.white)
                            .background(Color.accentColor)
                            .cornerRadius(6)
                            Spacer()
                        }
                        .frame(width: UIScreen.main.bounds.size.width/2, height: UIScreen.main.bounds.size.height/3, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .background(Color(UIColor.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxHeight: (UIScreen.main.bounds.size.height/3 + 100), alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            }
            Spacer()
        }
    }
}

struct AddFriendsView_Previews: PreviewProvider {
    static var previews: some View {
        AddFriendsView()
    }
}
