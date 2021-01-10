//
//  EnhancedTextField.swift
//  Boast
//
//  Created by David Keimig on 9/16/20.
//

import SwiftUI

struct EnhancedTextField: UIViewRepresentable {
 
    var placeholder: String = ""
    @Binding var text: String
    @ObservedObject var enhancedTextFieldState: EnhancedTextFieldState
    var onComplete: () -> Void
    var autocomplete: Bool = true
    var autocaptialize: UITextAutocapitalizationType = .sentences
    var keyboardType: UIKeyboardType = .default
    var isSecureTextEntry: Bool = false
    private let textField = UITextField()
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    func getTintColor() -> UIColor {
        if self.colorScheme == .light {
            return UIColor.systemBackground.darker(by: 10.0)!
        } else {
            return UIColor.systemBackground.lighter(by: 10.0)!
        }
    }
 
    func makeUIView(context: Context) -> UITextField {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.autocapitalizationType = .sentences
        textField.isUserInteractionEnabled = true
        textField.placeholder = self.placeholder
        textField.autocorrectionType = self.autocomplete ? .yes : .no
        textField.autocapitalizationType = self.autocaptialize
        textField.keyboardType = self.keyboardType
        textField.isSecureTextEntry = self.isSecureTextEntry
        textField.leftView = paddingView
        textField.rightView = paddingView
        textField.leftViewMode = UITextField.ViewMode.always
        textField.rightViewMode = UITextField.ViewMode.always
        textField.delegate = context.coordinator
        return textField
    }
 
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        uiView.backgroundColor = self.getTintColor()
        if (enhancedTextFieldState.isActive) {
            uiView.becomeFirstResponder()
        } else {
            uiView.resignFirstResponder()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(textField: self, text: self.$text)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: EnhancedTextField
        @Binding var text: String

        init(textField: EnhancedTextField, text: Binding<String>) {
            self.parent = textField
            _text = text
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }

        func textFieldDidBeginEditing(_ textField: UITextField) {
            self.parent.enhancedTextFieldState.isActive = true
        }

        func textFieldDidEndEditing(_ textField: UITextField) {
            self.parent.enhancedTextFieldState.isActive = false
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.parent.enhancedTextFieldState.isActive = false
            self.parent.onComplete()
            return true
        }
        
    }
}

//struct EnhancedTextField_Previews: PreviewProvider {
//    
//    static var previews: some View {
//        EnhancedTextField(text: .constant("Hello"), enhancedTextFieldState: EnhancedTextFieldState(), onComplete: onComplete)
//    }
//}
