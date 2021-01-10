//
//  SuggestLoginView.swift
//  Boast
//
//  Created by David Keimig on 9/17/20.
//

import SwiftUI

struct SuggestLoginView: View {
    @Binding var providers: [OAuthProviderData]
    
    func getProviderButton(provider: OAuthProviderData) -> AnyView {
        switch(provider.id) {
        case "github.com":
            return AnyView(GitHubView())
        default:
            return AnyView(EmptyView())
        }
    }
    
    var body: some View {
        VStack {
            ForEach(self.providers) { provider in
                self.getProviderButton(provider: provider)
            }
        }
    }
}

struct SuggestLoginView_Previews: PreviewProvider {
    static var previews: some View {
        SuggestLoginView(providers: .constant([]))
    }
}
