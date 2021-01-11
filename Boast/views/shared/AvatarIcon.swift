//
//  AvatarIcon.swift
//  Boast
//
//  Created by David Keimig on 8/24/20.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage
import FirebaseUI

struct FirebaseAvatar: UIViewRepresentable {
    var uid: String
    
    func makeUIView(context: Context) -> UIImageView {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let reference = storageRef.child("\(uid).jpg")
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let placeholderImage = UIImage()
        imageView.sd_setImage(with: reference, placeholderImage: placeholderImage)
        return imageView
    }
    
    func updateUIView(_ uiView: UIImageView, context: Context) {
        uiView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    }
}

class AvatarModel: ObservableObject {
    var uid: String?
    var size: AvatarIconSize
    var handler: ListenerRegistration?
    @Published var avatarImage: UIImage?
    
    init(uid: String?, size: AvatarIconSize) {
        self.uid = uid
        self.size = size
        if self.uid != nil {
            let db = Firestore.firestore()
            let profileUrl =
                db.collection("profileUrls").document("\(self.uid!)_\(size.rawValue).jpg")
            self.handler = profileUrl.addSnapshotListener { (querySnapshot, error) in
                if error != nil {
                    print("Error getting profile url")
                } else {
                    let data = querySnapshot?.data()
                    if data != nil {
                        let filePath = data?["filePath"] as! String
                        let principal = (filePath as NSString).deletingPathExtension
                        let storage = Storage.storage()
                        let storageRef = storage.reference()
                        let reference = storageRef.child("\(principal).jpg")

                        reference.getData(maxSize: 1 * 1024 * 1024) { data, error in
                            if error != nil {
                            print("Download error")
                          } else {
                            self.avatarImage = UIImage(data: data!)
                          }
                        }
                    }
                }
            }
        }
    }
    
    deinit {
        if self.handler != nil {
            self.handler!.remove();
        }
    }
}

enum AvatarIconSize: String {
    case xsmall = "32x32"
    case small = "64x64"
    case medium = "128x128"
    case large = "256x256"
    case xlarge = "512x512"
}

struct AvatarIcon: View {
    var uid: String?
    var size: AvatarIconSize = .medium
    @ObservedObject var avatarModel: AvatarModel
    
    init(uid: String?, size: AvatarIconSize) {
        self.uid = uid
        self.size = size
        self.avatarModel = AvatarModel(uid: uid, size: size)
    }
    
    func getDims() -> CGFloat {
        switch(self.size) {
        case .xsmall:
            return 24
        case .small:
            return 52
        case .medium:
            return 100
        case .large:
            return 200
        case .xlarge:
            return 450
        }
    }
    
    var body: some View {
        Group {
            if (self.avatarModel.avatarImage != nil) && (self.uid != nil) {
                Image(uiImage: self.avatarModel.avatarImage!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: self.getDims(), height: self.getDims(), alignment: .center)
                    .clipShape(Circle())
            } else {
                Circle()
                    .fill(Color(UIColor.secondarySystemBackground))
                    .frame(width: self.getDims(), height: self.getDims(), alignment: .center)
            }
        }
    }
}

struct AvatarIcon_Previews: PreviewProvider {
    static var previews: some View {
        AvatarIcon(uid: "", size: .medium)
    }
}
