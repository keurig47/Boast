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
    @Published var editorValue: String = ""
    @Published var theme: String = ""
    @Published var syntax: String = ""
    @Published var backgroundColor: UIColor = UIColor.systemBackground
    @Published var color: UIColor = UIColor.label
    @Published var snapshot: UIImage?
    
    var kguard: KeyboardGuardian?
    
    func register(kguard: KeyboardGuardian) {
        self.kguard = kguard
    }
    
    func getValue() {
        self.kguard?.getValue()
    }
    
}

struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }

    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        
        class CustomController: UIViewController {
            
            override func viewWillAppear(_ animated: Bool) {
                super.viewWillAppear(animated)
                self.setNeedsStatusBarAppearanceUpdate()
            }
            
            override var preferredStatusBarStyle: UIStatusBarStyle {
                return .lightContent
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
    @EnvironmentObject var editorState: EditorState
    
    var body: some View {
        ZStack {
            VStack {
                CodeEditor()
                    .navigationBarTitleDisplayMode(.inline)
                    .background(
                        NavigationLink(destination: PostEditor(showEditor: $showEditor)
                                        .environmentObject(editorState), isActive: $showNext) {
                          EmptyView()
                        }
                    )
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing ) {
                            Button("Next") {
                                showNext = true
                                self.editorState.getValue()
                            }
                        }
                        ToolbarItem(placement: .principal) {
                            Text("Boast")
                                .font(.title3)
                                .foregroundColor(Color(editorState.color))
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
            .background(NavigationConfigurator { nc in
                let appearance = UINavigationBarAppearance()
                if !showNext {
                    nc.navigationBar.isTranslucent = false
                    appearance.shadowColor = .clear
                }
                appearance.backgroundColor = showNext ? .systemBackground: editorState.backgroundColor
                nc.navigationBar.standardAppearance = appearance
                nc.navigationBar.scrollEdgeAppearance = appearance
                nc.navigationBar.barTintColor = showNext ? .systemBackground: editorState.backgroundColor
            })
        }
        .background(Color(editorState.backgroundColor))
        .ignoresSafeArea()
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
}

struct EditorModal: View {
    
    @Binding var showEditor: Bool
    let editorState: EditorState = EditorState()
    
    var body: some View {
        NavigationView {
            EditorView(showEditor: $showEditor)
                .environmentObject(editorState)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
}

struct EditorView_Previews: PreviewProvider {
    static let store: Store = Store()
    
    static var previews: some View {
        EditorView(showEditor: .constant(true))
            .environmentObject(store)
    }
}
