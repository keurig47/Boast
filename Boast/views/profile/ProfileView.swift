//
//  ProfileView.swift
//  Boast
//
//  Created by David Keimig on 8/20/20.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @State var selectedIndex: Int = 0
    @State private var isPresented = false
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var store: Store
    @EnvironmentObject var authState: AuthStateProvider

    let tabs = ["Posts", "Tagged", "Acheivements"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(alignment: .leading, pinnedViews: [.sectionHeaders]) {
                    HStack(alignment: .center) {
                        VStack {
                            AvatarIcon()
                            Text("David Keimig")
                                .font(.subheadline)
                        }
                        HStack() {
                            Spacer()
                            VStack {
                                Text("5")
                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                Text("Posts")
                                    .font(.caption)
                            }
                            .padding(.trailing)
                            VStack {
                                Text("2")
                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                Text("Followers")
                                    .font(.caption)
                            }
                            .padding(.trailing)
                            VStack {
                                Text("1")
                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                Text("Following")
                                    .font(.caption)
                            }
                            Spacer()
                        }
                    }
                    .padding([.leading, .trailing], 12)
                    LazyVStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, pinnedViews: [.sectionHeaders]) {
                        Section(header: VStack {
                                Picker("Selection", selection: $selectedIndex) {
                                    ForEach(0 ..< tabs.count) { index in
                                        Text(self.tabs[index]).tag(index)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                Divider()
                            }
                            .padding(.all, 8)
                        .background(Color(UIColor.systemBackground))) {
                            ForEach(self.store.feed) { item in
                                Post(data: item, user: authState.currentUser?.uid)
                            }
                        }
                    }
                }
                .background(NavigationConfigurator { nc in
                    let appearance = UINavigationBarAppearance()
                    appearance.backgroundColor = .systemBackground
                    appearance.shadowColor = .clear
                    nc.navigationBar.standardAppearance = appearance
                    nc.navigationBar.scrollEdgeAppearance = appearance
                })
                .navigationTitle("Keurig")
                .toolbar {
                    Button(action: {
                        self.isPresented.toggle()
                    }, label: {
                        Image(systemName: "line.horizontal.3")
                    })
                }.sheet(isPresented: $isPresented, content: {
                    List {
                        Text("Log Out")
                            .onTapGesture(perform: {
                                do {
                                    try Auth.auth().signOut()
                                    self.isPresented.toggle()
                                } catch {
                                    print("Error signing out")
                                }
                            })
                    }
                })
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
