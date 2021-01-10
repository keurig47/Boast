//
//  ProfileSettingsView.swift
//  Boast
//
//  Created by David Keimig on 9/23/20.
//

import SwiftUI
import FirebaseAuth

struct ProfileSettingsView: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var store: Store
    
    var body: some View {
        VStack {
            List {
                Text("Log Out")
                    .onTapGesture(perform: {
                        do {
                            try Auth.auth().signOut()
                            self.isPresented.toggle()
                        } catch {
                            print("Error signing out")
                        }
                    })
                Text("Toggle Theme")
                    .onTapGesture(perform: {
                        store.isLight.toggle()
                    })
            }
        }
    }
}

struct ProfileSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSettingsView(isPresented: .constant(true))
    }
}
