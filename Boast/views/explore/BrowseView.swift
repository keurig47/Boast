//
//  BrowseView.swift
//  Boast
//
//  Created by David Keimig on 10/6/20.
//

import SwiftUI
import UIKit
import SwiftUIPager

let testData = """
//
//  ExploreView.swift
//  Boast
//
//  Created by David Keimig on 8/20/20.
//

import SwiftUI

struct ExploreView: View {

    @EnvironmentObject var store: Store
    @StateObject var searchState = SearchState()
    @State var search: String = ""
    let highlighter = Highlighter()
    
    func getColumns() -> [GridItem] {
        if !searchState.isActive {
            return [GridItem(.adaptive(minimum: 200), spacing: 1)]
        }
        return [GridItem(spacing: 10, alignment: .leading)]
    }
        
    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: self.getColumns(), alignment: .leading, spacing: 1, pinnedViews: [.sectionHeaders]) {
                Section(header: SearchView(text: $search, searchState: searchState)) {
                    Group {
                        if !searchState.isActive {
                            ForEach(self.store.feed) { item in
                                ExploreEditor(item: item)
                                    .environmentObject(highlighter)
                            }
                        } else {
                            SearchResults(searchState: searchState)
                        }
                    }
                }
                .padding(.all, 0)
            }
            .background(NavigationConfigurator { nc in
                let appearance = UINavigationBarAppearance()
                appearance.backgroundColor = .systemBackground
                appearance.shadowColor = .clear
                nc.navigationBar.standardAppearance = appearance
                nc.navigationBar.scrollEdgeAppearance = appearance
            })
        }
        .navigationBarTitle("Explore")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Image(systemName: "ellipsis")
                })
            }
        }
    }
}


struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}

struct ExploreEditor: View {
    var item: PostData
    let editorState: EditorState = EditorState()
    @State var isActive: Bool = false
    
    var body: some View {
        VStack {
            NavigationLink(destination: PostView(data: item), isActive: self.$isActive) {
                EmptyView()
            }
            CodeViewer(
                defaultValue: item.editorValue
            )
            .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: 300, idealHeight: 300, maxHeight: 300, alignment: .leading)
            .onTapGesture {
                self.isActive = true
            }
        }
        .padding(.all, 0)
    }
}

"""

class PlayState: ObservableObject {
    @Published var time: Double = 0
}

//struct BrowseDetail: View {
//    var isPlaying: Bool
//    @EnvironmentObject var authState: AuthStateProvider
//    @StateObject var playState = PlayState()
//
//    var body: some View {
//        ZStack {
//            CodeViewer(
//                defaultValue: testData,
//                isPlaying: isPlaying,
//                playState: playState
//            )
//            .environmentObject(playState)
//            VStack {
//                Spacer()
//                Slider(value: self.$playState.time, in: 0...10000)
//            }
//            .padding([.leading, .trailing], 60)
//            .padding(.bottom)
//            VStack(alignment: .trailing) {
//                Spacer()
//                AvatarIcon(uid: self.authState.currentUser?.uid, size: .small)
//                    .padding()
//                Button(action: {}) {
//                    Image(systemName: "heart.fill")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .shadow(color: Color(UIColor.systemBackground).opacity(0.5), radius: 5)
//                        .frame(width: 35, height: 35)
//                        .foregroundColor(Color.primary.opacity(0.9))
//                }
//                .padding()
//                Button(action: {}) {
//                    Image(systemName: "message.fill")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 35, height: 35)
//                        .shadow(color: Color(UIColor.systemBackground).opacity(0.5), radius: 5)
//                        .foregroundColor(Color.primary.opacity(0.9))
//                }
//                .padding()
//                Button(action: {}) {
//                    Image(systemName: "paperplane.fill")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 35, height: 35)
//                        .shadow(color: Color(UIColor.systemBackground).opacity(0.5), radius: 5)
//                        .foregroundColor(Color.primary.opacity(0.9))
//                }
//                .padding()
//            }
//            .frame(minWidth: 0, idealWidth: 100, maxWidth: .infinity, minHeight: 0, idealHeight: 100, maxHeight: .infinity, alignment: .bottomTrailing)
//            .padding(.bottom)
//        }
//    }
//}

struct BrowseDetail: View {
    var isPlaying: Bool
    
    var body: some View {
        SCNCodeEditor(defaultValue: testData)
    }
}

struct BrowseView: View {
    @State var page: Int = 0
    let height = UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    var items = Array(0..<10)
    
    var body: some View {
        ZStack(alignment: .top) {
            BrowseDetail(isPlaying: true)
            BlurView()
                .frame(
                    minWidth: 0,
                    idealWidth: 400,
                    maxWidth: .infinity,
                    minHeight: height,
                    idealHeight: height,
                    maxHeight: height,
                    alignment: .top
                )
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarHidden(true)
    }
}
