//
//  GitHubView.swift
//  Boast
//
//  Created by David Keimig on 9/17/20.
//

import SwiftUI
import FirebaseAuth

struct GitHubView: View {
    let provider = OAuthProvider(providerID: "github.com")
    
    var body: some View {
        Button(action: {
            provider.scopes = ["user:email"]
            provider.getCredentialWith(nil) { credential, error in
                if error != nil {
                    print("Error connecting to Github")
                }
                if credential != nil {
                    Auth.auth().signIn(with: credential!) { authResult, error in
                        if error != nil {
                            print("Error authenticating with github")
                        }
                    }
                }
            }
        }, label: {
            HStack {
                Image("github-logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.primary)
                    .frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                Text("Sign in with GitHub")
                    .foregroundColor(.primary)
                    .bold()
            }
            .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: 50, idealHeight: 50, maxHeight: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.accentColor, lineWidth: 1)
            )
            .padding([.leading, .trailing])
        })
    }
}

struct GitHubView_Previews: PreviewProvider {
    static var previews: some View {
        GitHubView()
    }
}
