//
//  ActivityView.swift
//  Boast
//
//  Created by David Keimig on 9/8/20.
//

import SwiftUI

struct ActivityButtons: View {
    var item: ActivityData
    @EnvironmentObject var store: Store
    
    func followButtons() -> some View {
        FollowButton(user: store.currentUser?.uid, follower: item.fromUid)
            .frame(minWidth: 0, idealWidth: 100, maxWidth: 100, minHeight: 20, idealHeight: 20, maxHeight: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .padding(.leading)
    }
    
    var body: some View {
        switch(item.type) {
        case "FOLLOW":
            return self.followButtons()
        default:
            return self.followButtons()
        }
    }
}

struct ActivityView: View {
    @State var isActive: Bool = false
    @EnvironmentObject var store: Store
    
    func delete(at offsets: IndexSet) {
        removeActivityItems(activityItems: self.store.activity, offsets: offsets, uid: self.store.currentUser?.uid)
    }
    
    var body: some View {
        VStack {
            NavigationLink(destination: Text("Chats"), isActive: $isActive) {
                EmptyView()
            }
            if !self.store.activity.isEmpty {
                List {
                    ForEach(self.store.activity) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(item.body) ")
                                    .font(.headline)
                                    .padding(.bottom, 3)
                                Text(Date().timeIntervalSince(item.timestamp.dateValue()).stringFromTimeInterval())
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            ActivityButtons(item: item)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding([.top, .bottom])
                    }
                    .onDelete(perform: delete)
                }
                .listStyle(PlainListStyle())
            } else {
                VStack {
                    Image(systemName: "heart.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .padding()
                    Text("Activity On Your Posts")
                        .font(.title)
                        .padding()
                    Text("When someone likes or comments on one of your posts, you'll see it here.")
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .padding()
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Text("Share a snippet")
                            .font(.caption)
                            .bold()
                            .padding()
                    })
                }
                .padding()
            }
        }
        .navigationTitle("Inbox")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    self.isActive = true
                }, label: {
                    Image(systemName: "paperplane")
                })
            }
        }
    }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView()
    }
}
