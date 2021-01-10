//
//  CreateUsernameView.swift
//  Boast
//
//  Created by David Keimig on 9/16/20.
//

import SwiftUI

struct CreateUsernameView: View {
    @State var username: String = ""
    @State var disabledContinue: Bool = true
    @State var continueEnterName: Bool = false
    @State var validatingUsername: Bool = false
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
    
    func onComplete() {
        if !self.disabledContinue {
            self.validatingUsername = true
            validateUsername(username: self.username) { valid, message in
                self.validatingUsername = false
                if valid {
                    enhancedTextFieldState.isActive = false
                    self.continueEnterName = true
                    self.createUserStore.username = self.username
                }
            }
        }
    }
    
    func isValidName(_ username: String) -> Bool {
       let RegEx = "^\\w{3,25}$"
       let usernamePred = NSPredicate(format:"SELF MATCHES %@", RegEx)
       return usernamePred.evaluate(with: username)
    }
    
    var body: some View {
        VStack {
            NavigationLink(
                destination: EnterNameView(),
                isActive: self.$continueEnterName,
                label: { EmptyView() })
            VStack {
                Text("What do you want your username to be?")
                    .font(.title)
                    .bold()
                    .padding(.bottom)
                EnhancedTextField(
                    placeholder: "Username",
                    text: self.$username,
                    enhancedTextFieldState: enhancedTextFieldState,
                    onComplete: self.onComplete,
                    autocomplete: true,
                    autocaptialize: .none,
                    keyboardType: .default
                )
                .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: 50, idealHeight: 50, maxHeight: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .cornerRadius(6)
                .padding()
                .onChange(of: self.username, perform: { value in
                    DispatchQueue.main.async {
                        let valid = self.isValidName(value)
                        self.disabledContinue = !valid
                    }
                })
            }
            .padding(.top)
            Button(action: {
                self.onComplete()
            }, label: {
                if self.validatingUsername {
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
            .disabled(self.disabledContinue)
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

struct CreateUsernameView_Previews: PreviewProvider {
    static var previews: some View {
        CreateUsernameView()
    }
}
