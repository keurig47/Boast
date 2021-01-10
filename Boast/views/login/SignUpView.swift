//
//  SignUpView.swift
//  Boast
//
//  Created by David Keimig on 9/16/20.
//

import SwiftUI

class EnhancedTextFieldState: ObservableObject {
    @Published var isActive: Bool = false
}

struct SignUpView: View {
    @State var email: String = ""
    @State var disabledContinue: Bool = true
    @State var continueEnterPassword: Bool = false
    @State var validatingEmail: Bool = false
    @State var invalidEmail: String?
    @State var validateMessage: String?
    @State var providers: [OAuthProviderData] = []
    @StateObject var enhancedTextFieldState = EnhancedTextFieldState()
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @EnvironmentObject var createUserStore: CreateUserStore
    
    func getTintColor() -> Color {
        if self.colorScheme == .light {
            return Color(UIColor.systemBackground.darker(by: 10.0)!)
        } else {
            return Color(UIColor.systemBackground.lighter(by: 10.0)!)
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func onComplete() {
        if !self.disabledContinue {
            self.validatingEmail = true
            validateEmail(email: self.email) { valid, message, providers in
                self.validatingEmail = false
                if message != nil {
                    self.validateMessage = message
                }
                if valid {
                    createUserStore.email = self.email
                    enhancedTextFieldState.isActive = false
                    self.continueEnterPassword = true
                    self.validateMessage = nil
                } else {
                    self.invalidEmail = self.email
                    self.providers = providers!
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            NavigationLink(
                destination: CreatePasswordView(),
                isActive: self.$continueEnterPassword,
                label: { EmptyView() })
            VStack {
                Text("Let's get started")
                    .font(.title)
                    .bold()
                    .padding(.bottom)
                Text("What's your email?")
                    .padding(.bottom)
                EnhancedTextField(
                    placeholder: "Email",
                    text: self.$email,
                    enhancedTextFieldState: enhancedTextFieldState,
                    onComplete: self.onComplete,
                    autocomplete: false,
                    autocaptialize: .none,
                    keyboardType: .emailAddress
                )
                .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: 50, idealHeight: 50, maxHeight: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .cornerRadius(6)
                .padding()
                .onChange(of: self.email, perform: { value in
                    DispatchQueue.main.async {
                        let isValid = self.isValidEmail(self.email)
                        self.disabledContinue = !isValid
                    }
                })
            }
            .padding(.top)
            if self.validateMessage != nil {
                Text(self.validateMessage!)
                    .font(.caption)
                    .bold()
                    .padding(.bottom)
            }
            if !self.providers.isEmpty {
                SuggestLoginView(providers: self.$providers)
                    .padding(.bottom)
            }
            Button(action: {
                self.onComplete()
            }, label: {
                if self.validatingEmail {
                    ProgressView()
                        .frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                } else {
                    Text("Continue")
                        .bold()
                        .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: 50, idealHeight: 50, maxHeight: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.white)
                        .background(Color.accentColor)
                        .cornerRadius(6)
                        .padding([.leading, .trailing])
                }
            })
            .disabled(
                (self.disabledContinue) ||
                (self.invalidEmail == self.email)
            )
            Spacer()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                enhancedTextFieldState.isActive = true
            }
        }
        .onDisappear {
            enhancedTextFieldState.isActive = false
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
