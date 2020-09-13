//
//  HomeView.swift
//  Boast
//
//  Created by David Keimig on 8/19/20.
//

import SwiftUI

struct HomeView: View {
    
    @State var isActive: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                FeedView()
                .navigationTitle("Boast")
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            self.isActive = true
                        }, label: {
                            Image(systemName: "paperplane")
                        })
                    }
                })
                NavigationLink(destination: Text("Chats"), isActive: $isActive) {
                    EmptyView()
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
