//
//  SearchBar.swift
//  Boast
//
//  Created by David Keimig on 8/24/20.
//

import SwiftUI

struct SearchBar: UIViewRepresentable {

    @Binding var text: String
    @ObservedObject var searchState: SearchState

    class Coordinator: NSObject, UISearchBarDelegate {

        var parent: SearchBar
        @Binding var text: String
        @ObservedObject var searchState: SearchState

        init(_ parent: SearchBar, text: Binding<String>, searchState: SearchState) {
            self.parent = parent
            self._text = text
            self.searchState = searchState
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.setShowsCancelButton(false, animated: true)
            self.searchState.isActive = false
            searchBar.resignFirstResponder()
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.setShowsCancelButton(false, animated: true)
            self.searchState.isActive = false
            searchBar.resignFirstResponder()
        }
        
        func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
            searchBar.setShowsCancelButton(true, animated: true)
            self.searchState.isActive = true
            return true
        }
        
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self, text: $text, searchState: searchState)
    }

    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        let image = UIImage()
        searchBar.backgroundImage = image
        searchBar.backgroundColor = .clear
        searchBar.barTintColor = .clear
        searchBar.placeholder = "Search"
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar,
                      context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
}

//struct SearchBar_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchBar(text: .constant(""), isActive: .constant(true))
//    }
//}
