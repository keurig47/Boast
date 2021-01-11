//
//  ProfileEditor.swift
//  Boast
//
//  Created by David Keimig on 9/23/20.
//

import SwiftUI

struct ProfileEditor: View {
    @Binding var isPresented: Bool
    @Binding var avatarImage: UIImage?
    @State var showingImagePicker: Bool = false
    
    func getDim() -> CGFloat {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width / 3
        let screenHeight = screenSize.height / 3
        return min(screenWidth, screenHeight)
    }
    
    var body: some View {
        VStack {
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
                        .font(.system(size: self.getDim() / 3))
                        .foregroundColor(Color(UIColor.systemBackground))
                }
                .padding()
            }
            Button(action: {
                self.showingImagePicker = true
            }, label: {
                Text("Change Profile Photo")
                    .foregroundColor(.accentColor)
            })
            List {
                HStack {
                    Text("Name")
                    Spacer()
                    Text("David Keimig")
                }
                HStack {
                    Text("Username")
                    Spacer()
                    Text("David Keimig")
                }
                HStack {
                    Text("Website")
                    Spacer()
                    Text("David Keimig")
                }
                HStack {
                    Text("Bio")
                    Spacer()
                    Text("David Keimig")
                }
            }
            Spacer()
        }
        .sheet(isPresented: self.$showingImagePicker) {
            ImagePicker(image: self.$avatarImage)
        }
    }
}

struct ProfileEditor_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEditor(isPresented: .constant(true), avatarImage: .constant(UIImage()))
    }
}
