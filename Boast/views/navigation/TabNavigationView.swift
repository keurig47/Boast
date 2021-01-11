//
//  TabNavigationView.swift
//  Boast
//
//  Created by David Keimig on 9/1/20.
//

import SwiftUI

struct TabNavigationView: View {
    @State var currentTab = 1
    @State var showEditor = false
    @EnvironmentObject var store: Store
    @EnvironmentObject var authState: AuthStateProvider
    let profileViewer = ProfileViewer()
    
    init() {
        UITabBar.appearance().alpha = 0
    }
    
    var body: some View {
        TabView(selection: $currentTab) {
            NavigationView {
                HomeView()
            }
            .tag(1)
            NavigationView {
                BrowseView()
            }
            .tag(2)
            NavigationView {
                ActivityView()
            }
            .tag(4)
            NavigationView {
                ProfileView(user: self.store.currentUser?.uid)
                    .environmentObject(profileViewer)
            }
            .tag(5)
        }
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Button(action: {
                    currentTab = 1
                }, label: {
                    Image(systemName: (currentTab == 1) ? "house.fill" : "house")
                })
                Spacer()
                Button(action: {
                    currentTab = 2
                }, label: {
                    Image(systemName: (currentTab == 2) ? "hand.draw.fill" : "hand.draw")
                })
                Spacer()
                Button(action: {
                    self.showEditor = true
                }, label: {
                    Image(systemName: (self.showEditor) ? "terminal.fill" : "terminal")
                })
                Spacer()
                Button(action: {
                    currentTab = 4
                }, label: {
                    Image(systemName: (currentTab == 4) ? "envelope.fill" : "envelope")
                })
                Spacer()
                Button(action: {
                    currentTab = 5
                }, label: {
                    Image(systemName: (currentTab == 5) ? "person.fill" : "person")
                })
            }
        }
        .fullScreenCover(isPresented: $showEditor) {
//            EditorControllerWrapper()
            EditorModal(showEditor: $showEditor)
                .environmentObject(store)
        }
    }
}

struct TabNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        TabNavigationView()
    }
}
