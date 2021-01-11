//
//  CreatePasswordView.swift
//  Boast
//
//  Created by David Keimig on 9/16/20.
//

import SwiftUI

func checkStrength(password: String) -> String {
    let len = password.count
    let range = NSRange(location: 0, length: password.utf16.count)
    var strength: Int = 0
    
    switch len {
        case 0:
            return ""
        case 1...4:
            strength += 1
        case 5...8:
            strength += 2
        default:
            strength += 3
    }
    
    // Upper case, Lower case, Number & Symbols
    let patterns = ["^(?=.*[A-Z]).*$", "^(?=.*[a-z]).*$", "^(?=.*[0-9]).*$", "^(?=.*[!@#%&-_=:;\"'<>,`~\\*\\?\\+\\[\\]\\(\\)\\{\\}\\^\\$\\|\\\\\\.\\/]).*$"]
    
    for pattern in patterns {
        let regex = try! NSRegularExpression(pattern: pattern)
        if regex.firstMatch(in: password, options: [], range: range) != nil {
            strength += 1
        }
    }
    
    switch strength {
    case 0:
        return ""
    case 1...3:
        return "Weak"
    case 4...6:
        return "Moderate"
    default:
        return "Strong"
    }
}

struct CreatePasswordView: View {
    @State var strength: String = ""
    @State var password: String = ""
    @State var continueName: Bool = false
    @StateObject var enhancedTextFieldState = EnhancedTextFieldState()
    @EnvironmentObject var createUserStore: CreateUserStore
    
    func getPasswordColor(strength: String) -> Color {
        switch(strength) {
        case "Weak":
            return Color.red
        case "Moderate":
            return Color.yellow
        case "Strong":
            return Color.green
        default:
            return Color.primary
        }
    }
    
    func onComplete() {
        if self.strength == "Strong" {
            enhancedTextFieldState.isActive = false
            createUserStore.password = password
            self.continueName = true
        }
    }
    
    var body: some View {
        VStack {
            NavigationLink(
                destination: CreateUsernameView(),
                isActive: self.$continueName,
                label: { EmptyView() })
            Text("Create your Boast password")
                .font(.title)
                .bold()
                .padding(.bottom)
            HStack{
                if self.strength != "" {
                    Text("Password strength: ")
                        .font(.caption)
                        .bold()
                        .foregroundColor(.secondary)
                }
                Text(self.strength)
                    .font(.caption)
                    .bold()
                    .foregroundColor(self.getPasswordColor(strength: self.strength))
            }
            .padding(.bottom)
            EnhancedTextField(
                placeholder: "Password",
                text: self.$password,
                enhancedTextFieldState: enhancedTextFieldState,
                onComplete: self.onComplete,
                autocomplete: false,
                autocaptialize: .none,
                keyboardType: .default,
                isSecureTextEntry: false
            )
            .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: 50, idealHeight: 50, maxHeight: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .cornerRadius(6)
            .padding()
            .onChange(of: self.password, perform: { value in
                DispatchQueue.main.async {
                    self.strength = checkStrength(password: value)
                }
            })
            Button(action: {
                self.onComplete()
            }, label: {
                Text("Continue")
                    .bold()
                    .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: 50, idealHeight: 50, maxHeight: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.white)
                    .background(Color.accentColor)
                    .cornerRadius(6)
                    .padding([.leading, .trailing])
            })
            .disabled(self.strength != "Strong")
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
        .padding(.top)
    }
}

struct CreatePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePasswordView()
    }
}
