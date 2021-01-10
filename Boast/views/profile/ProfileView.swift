//
//  ProfileView.swift
//  Boast
//
//  Created by David Keimig on 8/20/20.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class ProfileViewer: ObservableObject {
    var authHandle: AuthStateDidChangeListenerHandle?
    var feedDataHandle: ListenerRegistration?
    var userDataHandle: ListenerRegistration?
    @Published var userData: UserData?
    @Published var currentUser: String?
    @Published var feed: [PostData] = []
    
    func start(viewingUser: String?) {
        authHandle = Auth.auth().addStateDidChangeListener { (auth, user) in
            self.currentUser = viewingUser
            if user != nil && viewingUser != nil {
                self.fetchCurrentUser(uid: viewingUser)
                self.fetchFeed(uid: viewingUser)
            }
        }
    }
    
    func fetchCurrentUser(uid: String?) {
        if uid != nil {
            let db = Firestore.firestore()
            userDataHandle =
                db
                .collection("users")
                .document(uid!)
                .addSnapshotListener { (document, error) in
                    do {
                        let decoder = JSONDecoder()
                        if document != nil {
                            let data = document!.data() as Any
                            let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                            self.userData = try decoder.decode(UserData.self, from: jsonData)
                        }
                    } catch {
                        print("Serialization error", error)
                    }
                }
        }
    }
    
    func fetchFeed(uid: String?) {
        let db = Firestore.firestore()
        feedDataHandle =
            db
            .collection("feed")
            .document(uid!)
            .collection("posts")
            .order(by: "createTime", descending: true)
            .addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                self.feed = documents.map { document -> PostData in
                    let data = document.data()
                    let id = document.documentID
                    let author = data["author"] as! String
                    let caption = data["caption"] as! String
                    let editorValue = data["editorValue"] as! String
                    let displayName = data["displayName"] as! String
                    let mention = data["mention"] as! String
                    let likes = data["likes"] as! Int
                    let roles = data["roles"] as! [String : String]
                    let syntax = data["syntax"] as! String
                    let theme = data["theme"] as! String
                    let createTime = data["createTime"] as! Timestamp
                    return PostData(id: "\(id)_profile", author: author, caption: caption, editorValue: editorValue, displayName: displayName, likes: likes, mention: mention, roles: roles, syntax: syntax, theme: theme, createTime: createTime)
                }
            }
    }
    
    func kill() {
        if userDataHandle != nil {
            Auth.auth().removeStateDidChangeListener(authHandle!)
            feedDataHandle?.remove()
            userDataHandle?.remove()
        }
    }
    
    deinit {
        self.kill()
    }
}

struct ProfileView: View {
    var user: String?
    @EnvironmentObject var profileViewer: ProfileViewer
    @State var selectedIndex: Int = 0
    @State private var isPresented = false
    @State private var isEditProfile = false
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var store: Store

    let tabs = ["Posts", "Tagged"]

    var body: some View {
        
        if self.user != nil {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    VStack {
                        HStack(alignment: .center) {
                            VStack(alignment: .center) {
                                AvatarIcon(uid: self.user!, size: .medium)
                                Text(profileViewer.userData?.displayName ?? "")
                                    .font(.caption)
                                    .bold()
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
                        .padding(.bottom)
                        if self.user! == self.store.currentUser?.uid {
                            Button(action: {
                                self.isEditProfile = true
                                self.isPresented = true
                            }, label: {
                                Text("Edit Profile")
                                    .font(.caption)
                                    .foregroundColor(.primary)
                                    .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: 20, idealHeight: 20, maxHeight: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                    .padding(5)
                                    .background(Color(UIColor.secondarySystemBackground))
                                    .overlay (
                                        RoundedRectangle(cornerRadius: 3)
                                            .stroke(Color(UIColor.separator))
                                    )
                            })
                        } else {
                            HStack {
                                FollowButton(user: profileViewer.currentUser, follower: self.user!)
                                Button(action: {}, label: {
                                    Text("Message")
                                        .font(.caption)
                                        .foregroundColor(.primary)
                                        .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: 20, idealHeight: 20, maxHeight: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                        .padding(5)
                                        .background(Color(UIColor.secondarySystemBackground))
                                        .clipShape(RoundedRectangle(cornerRadius: 3))
                                        .overlay (
                                            RoundedRectangle(cornerRadius: 3)
                                                .stroke(Color(UIColor.separator))
                                        )
                                })
                            }
                        }
                    }
                    .padding([.top, .leading, .trailing], 12)
                    VStack {  //(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, pinnedViews: [.sectionHeaders])
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
                            ForEach(self.profileViewer.feed) { item in
                                Post(data: item, user: profileViewer.currentUser, isPlaying: true)
                            }
                        }
                    }
                }
//                .background(NavigationConfigurator { nc in
//                    let appearance = UINavigationBarAppearance()
//                    appearance.backgroundColor = .systemBackground
//                    appearance.shadowColor = .clear
//                    nc.navigationBar.standardAppearance = appearance
//                    nc.navigationBar.scrollEdgeAppearance = appearance
//                })
                .navigationTitle(profileViewer.userData?.displayName ?? "")
                .toolbar {
                    Button(action: {
                        self.isEditProfile = false
                        self.isPresented.toggle()
                    }, label: {
                        Image(systemName: "line.horizontal.3")
                    })
                }
                .fullScreenCover(isPresented: $isPresented) {
                    ProfileOptionChooser(isPresented: $isPresented, isEditProfile: $isEditProfile)
                        .environmentObject(store)
                }
                .onAppear {
                    self.profileViewer.start(viewingUser: self.user)
                }
            }
        } else {
            Text("Loading user...")
        }
    }
}

struct ProfileOptionChooser: View {
    @Binding var isPresented: Bool
    @Binding var isEditProfile: Bool
    @State var avatarImage: UIImage?
    @EnvironmentObject var store: Store
    
    var body: some View {
        Group {
            if self.isEditProfile {
                NavigationView {
                    ProfileEditor(isPresented: self.$isPresented, avatarImage: self.$avatarImage)
                        .navigationTitle("Profile")
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button(action: {
                                    self.isPresented.toggle()
                                }, label: {
                                    Text("Cancel")
                                })
                            }
                            ToolbarItem(placement: .principal) {
                                Text("Edit Profile")
                            }
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: {
                                    if self.avatarImage != nil && (store.currentUser?.uid != nil) {
                                        let storage = Storage.storage()
                                        let storageRef = storage.reference()
                                        let data = self.avatarImage!.jpegData(compressionQuality: 1.0)!
                                        let metaData = StorageMetadata()
                                        metaData.contentType = "image/jpeg"
                                        metaData.customMetadata = [
                                            "uid": (store.currentUser?.uid)!
                                        ]
                                        let avatarRef = storageRef.child("\(UUID().uuidString).jpg")
                                        avatarRef.putData(data, metadata: metaData) { (meta, error) in
                                            print("Uploading...")
                                        }
                                    }
                                    self.isPresented.toggle()
                                }, label: {
                                    Text("Done")
                                })
                            }
                        }
                }
            } else {
                NavigationView {
                    ProfileSettingsView(isPresented: self.$isPresented)
                    .navigationTitle("Settings")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: {
                                self.isPresented.toggle()
                            }, label: {
                                Text("Cancel")
                            })
                        }
                    }
                }
            }
        }
    }
    
}

//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView()
//    }
//}
