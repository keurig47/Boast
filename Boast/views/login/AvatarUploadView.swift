//
//  AvatarUploadView.swift
//  Boast
//
//  Created by David Keimig on 9/16/20.
//

import SwiftUI
import FirebaseAuth

struct AvatarUploadView: View {
    @State var showingImagePicker: Bool = false
    @State var avatarImage: UIImage?
    @EnvironmentObject var createUserStore: CreateUserStore
    
    func getDim() -> CGFloat {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width / 2
        let screenHeight = screenSize.height / 2
        return min(screenWidth, screenHeight)
    }
    
    var body: some View {
        VStack {
            Text("Create your avatar")
                .font(.title)
                .bold()
                .padding(.bottom)
            if self.avatarImage != nil {
                Image(uiImage: self.avatarImage!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(
                        Circle()
                            .size(CGSize(width: self.getDim(), height: self.getDim()))
                    )
                    .frame(width: self.getDim(), height: self.getDim(), alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .padding()
            } else {
                ZStack {
                    Circle()
                        .frame(width: self.getDim(), height: self.getDim(), alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                    Text("DK")
                        .font(.system(size: self.getDim() / 2))
                        .foregroundColor(Color(UIColor.systemBackground))
                }
                .padding()
            }
            HStack {
                Button(action: {
                    self.showingImagePicker = true
                }, label: {
                    Text("Choose an image")
                        .bold()
                        .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: 50, idealHeight: 50, maxHeight: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.white)
                        .background(Color.accentColor)
                        .cornerRadius(6)
                        .padding([.leading, .trailing])
                })
                .animation(.easeIn)
                if self.avatarImage != nil {
                    Button(action: {
                        self.createUserStore.avatar = self.avatarImage
                        Auth.auth().createUser(withEmail: self.createUserStore.email, password: self.createUserStore.password) { (result, error) in

                        }
                    }, label: {
                        Text("Continue")
                            .bold()
                            .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: 50, idealHeight: 50, maxHeight: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .foregroundColor(.white)
                            .background(Color.accentColor)
                            .cornerRadius(6)
                            .padding([.leading, .trailing])
                    })
                    .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/)
                }
            }
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Text("Skip")
                    .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: 50, idealHeight: 50, maxHeight: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .cornerRadius(6)
                    .padding([.leading, .trailing])
            })
            Spacer()
        }
        .sheet(isPresented: self.$showingImagePicker) {
            ImagePicker(image: self.$avatarImage)
        }
    }
}

struct AvatarUploadView_Previews: PreviewProvider {
    static var previews: some View {
        AvatarUploadView()
    }
}
