//
//  EditorView.swift
//  Boast
//
//  Created by David Keimig on 8/25/20.
//

import SwiftUI
import Firebase

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

class EditorState: ObservableObject {
    @Published var start: Bool = true
    @Published var editorValue: String = ""
    @Published var theme: String = ""
    @Published var syntax: String = ""
    @Published var backgroundColor: UIColor = UIColor.systemBackground
    @Published var color: UIColor = UIColor.label
    @Published var snapshot: UIImage?
    
//    var kguard: KeyboardGuardian?
//
//    func register(kguard: KeyboardGuardian) {
//        self.kguard = kguard
//    }
//
    func getValue() {
//        self.kguard?.getValue()
    }
    
}

struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }

    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        
        class CustomController: UIViewController {
            
            override func viewWillAppear(_ animated: Bool) {
                super.viewWillAppear(animated)
                self.modalPresentationCapturesStatusBarAppearance = true
                self.setNeedsStatusBarAppearanceUpdate()
            }
            
            override func viewDidAppear(_ animated: Bool) {
                super.viewDidAppear(animated)
                self.setNeedsStatusBarAppearanceUpdate()
            }
            
            override var preferredStatusBarStyle: UIStatusBarStyle {
                return .lightContent
            }
            
            override var prefersStatusBarHidden: Bool {
                return true
            }
            
        }
        
        return CustomController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }

}

struct EditorView: View {
    @Binding var showEditor: Bool
    @State var showNext: Bool = false
    @State var text: String = ""
    @StateObject var highlighter: Highlighter = Highlighter()
    //@EnvironmentObject var editorState: EditorState
    
    var body: some View {
        VStack {
            CodeEditor()
        }
    }
}

struct EditorModal: View {
    @Binding var showEditor: Bool
    @State var showNext: Bool = false
    @State var currString: String = ""
    @ObservedObject var editorState: EditorState = EditorState()
    
    var body: some View {
        NavigationView {
            VStack {
                HighlightJSView(defaultValue: "", currString: self.$currString)
                NavigationLink(
                    destination: PostEditor(showEditor: self.$showEditor, currString: self.$currString)
                        .environmentObject(self.editorState),
                    isActive: self.$showNext,
                    label: {
                        EmptyView()
                    })
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing ) {
                        Button("Next") {
                            self.showNext = true
                        }
                    }
                    ToolbarItem(placement: .principal) {
                        Text("Boast")
                            .font(.title3)
                    }
                    ToolbarItem(placement: .navigationBarLeading ) {
                        Button(action: {
                            self.showEditor.toggle()
                        }, label: {
                            Text("Cancel")
                        })
                    }
                }
        }
        .ignoresSafeArea(.keyboard)
    }
    
}

struct EditorView_Previews: PreviewProvider {
    static let store: Store = Store()
    
    static var previews: some View {
        EditorView(showEditor: .constant(true))
            .environmentObject(store)
    }
}
