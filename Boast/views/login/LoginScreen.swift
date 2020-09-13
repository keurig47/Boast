//
//  LoginScreen.swift
//  Boast
//
//  Created by David Keimig on 9/1/20.
//

import SwiftUI
import FirebaseUI

struct LoginScreenController: UIViewControllerRepresentable {
        
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let authUI = FUIAuth.defaultAuthUI()
        let providers : [FUIAuthProvider] = [
            FUIEmailAuth(),
            FUIGoogleAuth(),
        ]
        authUI?.providers = providers
        authUI?.delegate = context.coordinator
        let authViewController = authUI?.authViewController()
        return authViewController!
    }

    func updateUIViewController(_ loginScreenController: UINavigationController, context: Context) {

    }
    
    class Coordinator: NSObject, FUIAuthDelegate {
        var parent: LoginScreenController

        init(_ loginScreenController: LoginScreenController) {
            self.parent = loginScreenController
        }
    }
    
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreenController()
    }
}
