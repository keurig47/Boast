//
//  AuthenticationView.swift
//  Boast
//
//  Created by David Keimig on 9/15/20.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseUI

struct AuthenticationView: View {
    let createUserStore: CreateUserStore = CreateUserStore()
    @State var username: String = ""
    @State var password: String = ""
    @State var isSignUp: Bool = false
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @StateObject var emailState = EnhancedTextFieldState()
    @StateObject var passwordState = EnhancedTextFieldState()
    
    func getTintColor() -> Color {
        if self.colorScheme == .light {
            return Color(UIColor.systemBackground.darker(by: 10.0)!)
        } else {
            return Color(UIColor.systemBackground.lighter(by: 10.0)!)
        }
    }
    
    func onUsernameComplete() {
        passwordState.isActive = true
    }
    
    func onPasswordComplete() {
        print(self.username)
        print(self.password)
        Auth.auth().signIn(withEmail: self.username, password: self.password) { (result, error) in
            print(error)
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Boast")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                ScrollView {
                    VStack {
                        EnhancedTextField(
                            placeholder: "Username",
                            text: self.$username,
                            enhancedTextFieldState: emailState,
                            onComplete: self.onUsernameComplete,
                            autocomplete: false,
                            autocaptialize: .none,
                            keyboardType: .emailAddress
                        )
                        .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: 50, idealHeight: 50, maxHeight: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .cornerRadius(6)
                        .padding([.leading, .top, .trailing])
                        EnhancedTextField(
                            placeholder: "Password",
                            text: self.$password,
                            enhancedTextFieldState: passwordState,
                            onComplete: self.onPasswordComplete,
                            autocomplete: false,
                            autocaptialize: .none,
                            keyboardType: .default,
                            isSecureTextEntry: true
                        )
                        .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: 50, idealHeight: 50, maxHeight: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .cornerRadius(6)
                        .padding()
                        Button(action: {
                            self.onPasswordComplete()
                        }, label: {
                            Text("Log in")
                                .bold()
                                .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: 50, idealHeight: 50, maxHeight: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .foregroundColor(.white)
                                .background(Color.accentColor)
                                .cornerRadius(6)
                                .padding([.leading, .trailing])
                        })
                        HStack {
                            Rectangle()
                                .fill(Color(UIColor.separator))
                                .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: 1, idealHeight: 1, maxHeight: 1, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            Text("OR")
                                .font(.caption)
                                .bold()
                                .foregroundColor(Color(UIColor.separator))
                            Rectangle()
                                .fill(Color(UIColor.separator))
                                .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: 1, idealHeight: 1, maxHeight: 1, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        }
                        .padding()
                        FacebookView()
                            .padding(.bottom)
                        GitHubView()
                            .padding(.bottom)
                    }
                }
                Spacer()
                Divider()
                HStack {
                    Text("Don't have an account?")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    NavigationLink(
                        destination: SignUpView(),
                        isActive: self.$isSignUp,
                        label: {
                            Text("Sign Up.")
                                .font(.caption)
                        }
                    )
                }
                .padding([.top, .bottom])
            }
            .navigationBarHidden(true)
        }
        .environmentObject(createUserStore)
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
    }
}
