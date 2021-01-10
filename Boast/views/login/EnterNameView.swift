//
//  EnterNameView.swift
//  Boast
//
//  Created by David Keimig on 9/16/20.
//

import SwiftUI

struct EnterNameView: View {
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var continueAvatar: Bool = false
    @State private var showingAlert = false
    @StateObject var firstNameState = EnhancedTextFieldState()
    @StateObject var lastNameState = EnhancedTextFieldState()
    @EnvironmentObject var createUserStore: CreateUserStore
    
    func onFirstName() {
        lastNameState.isActive = true
    }
    
    func onLastName() {
        self.continueAvatar = true
        self.createUserStore.firstName = self.firstName
        self.createUserStore.lastName = self.lastName
    }

    var body: some View {
        VStack {
            NavigationLink(
                destination: AvatarUploadView(),
                isActive: self.$continueAvatar,
                label: { EmptyView() })
            Text("What's your name?")
                .font(.title)
                .bold()
                .padding(.bottom)
            EnhancedTextField(
                placeholder: "First Name",
                text: self.$firstName,
                enhancedTextFieldState: firstNameState,
                onComplete: self.onFirstName,
                autocomplete: false,
                autocaptialize: .words,
                keyboardType: .default
            )
            .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: 50, idealHeight: 50, maxHeight: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .cornerRadius(6)
            .padding([.leading, .top, .trailing])
            EnhancedTextField(
                placeholder: "Last Name",
                text: self.$lastName,
                enhancedTextFieldState: lastNameState,
                onComplete: self.onLastName,
                autocomplete: false,
                autocaptialize: .words,
                keyboardType: .default
            )
            .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: 50, idealHeight: 50, maxHeight: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .cornerRadius(6)
            .padding()
            Button(action: {
                self.showingAlert = true
            }) {
                Text("What is this used for?")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding([.leading, .bottom, .trailing])
                
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Help"), message: Text("Boast uses your name to allow other users to easily search for you. If you would prefer not to share this information, please press the skip button."), dismissButton: .default(Text("Got it!"))
                )
            }
            Button(action: {
                self.continueAvatar = true
            }, label: {
                Text("Continue")
                    .bold()
                    .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: 50, idealHeight: 50, maxHeight: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.white)
                    .background(Color.accentColor)
                    .cornerRadius(6)
                    .padding([.leading, .trailing])
            })
            .disabled((self.firstName.isEmpty || self.lastName.isEmpty))
            Button(action: {
                self.continueAvatar = true
                self.createUserStore.firstName = ""
                self.createUserStore.lastName = ""
            }, label: {
                Text("Skip")
                    .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: 50, idealHeight: 50, maxHeight: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .cornerRadius(6)
                    .padding([.leading, .trailing])
            })
            Spacer()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                firstNameState.isActive = true
            }
        }
        .onDisappear {
            firstNameState.isActive = false
            lastNameState.isActive = false
        }
        .padding(.top)
    }
}

struct EnterNameView_Previews: PreviewProvider {
    static var previews: some View {
        EnterNameView()
    }
}
