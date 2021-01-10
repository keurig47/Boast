//
//  SearchView.swift
//  Boast
//
//  Created by David Keimig on 9/13/20.
//

import SwiftUI
import Firebase
import Combine

class SearchState: ObservableObject {
    @Published var text: String = ""
    @Published var isActive: Bool = false
    @Published var searchResults: [ElasticResult] = []
    var publisher: AnyCancellable?
    
    init() {
        self.publisher = $text
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .flatMap { match in
                return Future<Data, Never> { promise in
                    searchUsers(match: match) { data in
                        promise(.success(data!))
                    }
                }
            }
            .decode(type: [ElasticResult].self, decoder: JSONDecoder())
            .assertNoFailure()
            .assign(to: \.searchResults, on: self)
    }
}

struct SearchView: View {
    @Binding var text: String
    @ObservedObject var searchState: SearchState
    @State var selectedIndex: Int = 0
    let tabs: [String] = ["Posts", "Users", "Tags"]
    
    var body: some View {
        VStack {
            SearchBar(searchState: searchState)
                .padding(.vertical, -10)
                .padding(.horizontal, 10)
            if !self.searchState.isActive {
                Divider()
            } else {
                Picker("Selection", selection: $selectedIndex) {
                    ForEach(0 ..< tabs.count) { index in
                        Text(self.tabs[index]).tag(index)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding([.leading, .trailing])
            }
        }
        .background(Color(UIColor.systemBackground))
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(text: .constant("Test"), searchState: SearchState())
    }
}
