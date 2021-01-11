//
//  SearchBar.swift
//  Boast
//
//  Created by David Keimig on 8/24/20.
//

import SwiftUI

struct SearchBar: UIViewRepresentable {

    @ObservedObject var searchState: SearchState

    class Coordinator: NSObject, UISearchBarDelegate {

        var parent: SearchBar
        @ObservedObject var searchState: SearchState

        init(_ parent: SearchBar, searchState: SearchState) {
            self.parent = parent
            self.searchState = searchState
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.setShowsCancelButton(false, animated: true)
            self.searchState.isActive = false
            searchBar.resignFirstResponder()
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            searchState.text = searchText
            searchBar.text = searchText
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
        return Coordinator(self, searchState: searchState)
    }

    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        let image = UIImage()
        searchBar.backgroundImage = image
        searchBar.backgroundColor = .clear
        searchBar.barTintColor = .clear
        searchBar.autocapitalizationType = .none
        searchBar.placeholder = "Search"
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar,
                      context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = searchState.text
    }
}

//struct SearchBar_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchBar(text: .constant(""), isActive: .constant(true))
//    }
//}
