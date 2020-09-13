//
//  RootView.swift
//  Boast
//
//  Created by David Keimig on 8/27/20.
//

import SwiftUI

struct RootView: View {
    let store: Store = Store()
    @ObservedObject var authState: AuthStateProvider = AuthStateProvider()
    
    var body: some View {
        Group {
            if authState.showLogin {
                LoginScreenController()
            }
            else {
                TabNavigationView()
                    .environmentObject(store)
                    .environmentObject(authState)
            }
        }

            
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
