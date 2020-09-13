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
    
    init() {
        UITabBar.appearance().alpha = 0
    }
    
    var body: some View {
        TabView(selection: $currentTab) {
            HomeView()
                .tag(1)
            ExploreView()
                .tag(2)
            ActivityView()
                .tag(3)
            ProfileView()
                .tag(4)
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
                    Image(systemName: (currentTab == 2) ? "magnifyingglass.circle.fill" : "magnifyingglass.circle")
                })
                Spacer()
                Button(action: {
                    showEditor = true
                }, label: {
                    Image(systemName: (showEditor) ? "terminal.fill" : "terminal")
                })
                Spacer()
                Button(action: {
                    currentTab = 3
                }, label: {
                    Image(systemName: (currentTab == 3) ? "heart.fill" : "heart")
                })
                Spacer()
                Button(action: {
                    currentTab = 4
                }, label: {
                    Image(systemName: (currentTab == 4) ? "person.fill" : "person")
                })
            }
        }
        .fullScreenCover(isPresented: $showEditor) {
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
