//
//  ImagePicker.swift
//  Boast
//
//  Created by David Keimig on 9/16/20.
//

import SwiftUI
import RSKImageCropper

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    let picker = UIImagePickerController()
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate, RSKImageCropViewControllerDelegate {
        
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
            self.parent.picker.popViewController(animated: true)
        }
        
        func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
            self.parent.picker.dismiss(animated: true)
            self.parent.image = croppedImage
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let image : UIImage = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage)!
            print(image)
            let imageCropVC = RSKImageCropViewController(image: image, cropMode: RSKImageCropMode.circle)
            imageCropVC.delegate = self
            picker.pushViewController(imageCropVC, animated: true)
        }
    }
}

struct ImagePicker_Previews: PreviewProvider {
    static var previews: some View {
        ImagePicker(image: .constant(UIImage()))
    }
}
