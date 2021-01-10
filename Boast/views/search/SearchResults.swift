//
//  SearchResults.swift
//  Boast
//
//  Created by David Keimig on 9/11/20.
//

import SwiftUI

struct SearchResults: View {
    @ObservedObject var searchState: SearchState
    let profileViewer: ProfileViewer = ProfileViewer()
    
    var body: some View {
        if !searchState.searchResults.isEmpty {
            Divider()
                .padding(.top, 8)
        }
        ForEach(searchState.searchResults) {
            item in
            VStack(alignment: .leading) {
                NavigationLink(destination: ProfileView(user: item._source.id).environmentObject(profileViewer)) {
                    SearchResult(item: item)
                        .frame(
                            minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/,
                            idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/,
                            maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,
                            minHeight: 50,
                            idealHeight: 50,
                            maxHeight: 50,
                            alignment: .center
                        )
                }
                Divider()
            }
        }
    }
}

struct SearchResults_Previews: PreviewProvider {
    static var previews: some View {
        SearchResults(searchState: SearchState())
    }
}

struct SearchResult: View {
    var item: ElasticResult
    
    var body: some View {
        HStack {
            AsyncImage(url: "https://i.pinimg.com/originals/51/f6/fb/51f6fb256629fc755b8870c801092942.png")
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40, alignment: .top)
            VStack(alignment: .leading) {
                Text(item._source.displayName ?? "David Keimig")
                    .font(.caption)
                    .bold()
                Text(item._source.email)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
        }
        .padding()
    }
}
