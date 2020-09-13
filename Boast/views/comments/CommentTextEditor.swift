//
//  CommentTextEditor.swift
//  Boast
//
//  Created by David Keimig on 9/13/20.
//

import SwiftUI

struct CommentTextEditor: UIViewRepresentable {
    @Binding var text: String
    @Binding var height: CGFloat
    
    func makeUIView(context: Context) -> UITextView  {
        let textEditor = UITextView()
        textEditor.font = .systemFont(ofSize: 14)
        textEditor.showsVerticalScrollIndicator = false
        context.coordinator.textView = textEditor
        textEditor.delegate = context.coordinator
        textEditor.layoutManager.delegate = context.coordinator
        return textEditor
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {

    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(dynamicSizeTextField: self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate, NSLayoutManagerDelegate {
        
        var dynamicHeightTextField: CommentTextEditor
        
        weak var textView: UITextView?

        
        init(dynamicSizeTextField: CommentTextEditor) {
            self.dynamicHeightTextField = dynamicSizeTextField
        }
        
        func textViewDidChange(_ textView: UITextView) {
            self.dynamicHeightTextField.text = textView.text
        }
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if (text == "\n") {
                textView.resignFirstResponder()
                return false
            }
            return true
        }
        
        func layoutManager(_ layoutManager: NSLayoutManager, didCompleteLayoutFor textContainer: NSTextContainer?, atEnd layoutFinishedFlag: Bool) {
            
            DispatchQueue.main.async { [weak self] in
                guard let textView = self?.textView else {
                    return
                }
                let size = textView.sizeThatFits(textView.bounds.size)
                print("SIZE", size)
                if self?.dynamicHeightTextField.height != size.height {
                    self?.dynamicHeightTextField.height = size.height
                }
            }

        }
    }
    
}

struct CommentTextEditor_Previews: PreviewProvider {
    static var previews: some View {
        CommentTextEditor(text: .constant("Test"), height: .constant(40))
    }
}
