//
//  ShareViewController.swift
//  Boast
//
//  Created by David Keimig on 9/18/20.
//

import SwiftUI

struct ShareViewController: UIViewControllerRepresentable {
    @Binding var showShare: Bool
    var copyString: String

    func makeUIViewController(context: Context) -> UIViewController {
        return context.coordinator
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: UIViewController {
        
        var parentController: ShareViewController
        var completionWithItemsHandler: UIActivityViewController.CompletionWithItemsHandler? = nil

        init(_ parentController: ShareViewController) {
            self.parentController = parentController
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.modalPresentationStyle = .overCurrentContext
        }

        override func viewDidAppear(_ animated: Bool) {
            share()
        }

        override func viewDidDisappear(_ animated: Bool) {
            self.parentController.showShare = false
        }
       
        func share() {
            let textToShare = [ self.parentController.copyString ]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.completionWithItemsHandler = { activity, success, items, error in
                self.parentController.showShare = false
                self.dismiss(animated: true)
            }
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
}

struct ShareViewController_Previews: PreviewProvider {
    static var previews: some View {
        ShareViewController(showShare: .constant(true), copyString: "")
    }
}
