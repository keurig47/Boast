//
//  ExploreView.swift
//  Boast
//
//  Created by David Keimig on 8/20/20.
//

import SwiftUI
import SwiftlySearch

struct ExploreView: View {

    @EnvironmentObject var store: Store
    @StateObject var searchState = SearchState()
    @State var search: String = ""
    
    let data = (1...200).map { "Item \($0)" }
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 200))], alignment: .leading, spacing: 3, pinnedViews: [.sectionHeaders]) {
                    Section(header: SearchView(text: $search, searchState: searchState)) {
                        Group {
                            if !searchState.isActive {
                                ForEach(self.store.feed) { item in
                                    ExploreEditor(item: item)
                                }
                            } else {
                                SearchResults()
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
            .padding([.leading, .trailing], 3)
            .navigationBarTitle("Explore")
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
            NavigationLink(destination: PostView(data: item).environmentObject(editorState), isActive: $isActive) {
                EmptyView()
            }
            CodeEditor(
                defaultValue: item.editorValue,
                options: [:],
                isUserInteractionEnabled: false,
                theme: item.theme,
                syntax: item.syntax
            )
            .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: 400, idealHeight: 400, maxHeight: 400, alignment: .leading)
            .onTapGesture {
                self.isActive = true
            }
            .environmentObject(editorState)
        }
        .padding(.all, 0)
    }
}
