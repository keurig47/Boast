//
//  GitHubView.swift
//  Boast
//
//  Created by David Keimig on 9/17/20.
//

import SwiftUI
import FirebaseAuth
//import FacebookCore
//import FacebookLogin

struct FacebookButton: UIViewRepresentable {
    
    func makeUIView(context: UIViewRepresentableContext<FacebookButton>) -> UIButton {
        let button = UIButton()
        button.setTitle("Sign in with Facebook", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        let logo = UIImage(named: "facebook-logo")
        logo?.withTintColor(UIColor.label)
        button.setImage(logo, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(context.coordinator, action: #selector(context.coordinator.login(sender:)), for: .touchUpInside)
        return button
    }

    func updateUIView(_ uiView: UIButton,
                      context: UIViewRepresentableContext<FacebookButton>) {
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    class Coordinator: UIViewController {
        
        @objc func login(sender: UIButton) {
//            let loginManager = LoginManager()
//            loginManager.logIn(permissions: ["public_profile", "email"], from: self) { result, error in
//                let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
//                print("AUTH TOKEN", credential)
//                Auth.auth().signIn(with: credential) { (authResult, error) in
//                    print("Logged in to firebase!")
//                }
//            }
        }
    }
}

struct FacebookView: View {
    var body: some View {
        VStack {
            FacebookButton()
                .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: 50, idealHeight: 50, maxHeight: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.accentColor, lineWidth: 1)
                )
                .padding([.leading, .trailing])
        }
    }
}

struct FacebookView_Previews: PreviewProvider {
    static var previews: some View {
        FacebookView()
    }
}
