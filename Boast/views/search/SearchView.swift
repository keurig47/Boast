//
//  SearchView.swift
//  Boast
//
//  Created by David Keimig on 9/13/20.
//

import SwiftUI

class SearchState: ObservableObject {
    @Published var isActive: Bool = false
}

struct SearchView: View {
    @Binding var text: String
    @ObservedObject var searchState: SearchState
    
    var body: some View {
        VStack {
            SearchBar(text: $text, searchState: searchState)
                .padding(.vertical, -10)
            Divider()
        }
        .background(Color(UIColor.systemBackground))
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(text: .constant("Test"), searchState: SearchState())
    }
}
