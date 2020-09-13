//
//  BoastApp.swift
//  Boast
//
//  Created by David Keimig on 8/18/20.
//

import SwiftUI
import Combine
import Firebase
import FirebaseCore

@main
struct BoastApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

struct BoastApp_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello, World!")
    }
}

