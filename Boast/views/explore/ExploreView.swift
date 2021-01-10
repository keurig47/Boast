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
                defaultValue: item.editorValue,
                isPlaying: false
            )
            .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: 300, idealHeight: 300, maxHeight: 300, alignment: .leading)
            .onTapGesture {
                self.isActive = true
            }
        }
        .padding(.all, 0)
    }
}
