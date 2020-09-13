//
//  FeedView.swift
//  Boast
//
//  Created by David Keimig on 8/20/20.
//

import SwiftUI

struct FeedView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var authState: AuthStateProvider
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack {
                ForEach(self.store.feed) { item in
                    Post(data: item, user: authState.currentUser?.uid)
                }
            }
        }
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
