//
//  CodeEditor.swift
//  Boast
//
//  Created by David Keimig on 9/1/20.
//

import SwiftUI

class EditorModel: ObservableObject {
    @Published var attributedText: NSAttributedString = NSAttributedString()
}

let highlighterTool = Highlighter()

struct CodeEditor: View {
    var defaultValue: String?
    
    var body: some View {
        HighlightJSView(
            defaultValue: defaultValue,
            currString: .constant("")
        )
    }
}

struct CodeViewer: View {
    var defaultValue: String?
    var isPlaying: Bool
    var playState: PlayState?
    @State var isHidden: Bool = true
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                CodeViewerWrapper(defaultValue: defaultValue, isPlaying: isPlaying, playState: playState)
//                    .blur(radius: 3)
//                if isPlaying {
//                    VStack {
//                        Text("Snippet")
//                            .font(.title2)
//                            .padding()
//                        Spacer()
//                        Text("Hello world code snippet that is useful for nothing!")
//                            .font(.caption)
//                            .multilineTextAlignment(.center)
//                        Spacer()
//                    }
//                    .frame(width: (2 * geometry.size.width/3), height: (2 * geometry.size.height/3), alignment: .center)
//                    .background(Color(UIColor.systemBackground).opacity(0.75))
//                    .cornerRadius(10)
//                }
            }
            .animation(.spring())
        }
    }
}

struct CodeViewerWrapper: UIViewRepresentable {
    var defaultValue: String?
    var isPlaying: Bool
    var playState: PlayState?
    
    func makeUIView(context: Context) -> CAViewContainer {
        let container = CAViewContainer()
        container.onUpdate = self.onUpdate
        if self.isPlaying {
            DispatchQueue.main.async {
                let attributedString = highlighterTool.highlight(text: defaultValue ?? "")
                container.setAttributed(attributedString)
            }
        }
        return container
    }
    
    func onUpdate(time: Double) {
        if playState != nil {
            playState!.time = time
        }
    }
    
    func updateUIView(_ uiView: CAViewContainer, context: Context) {
        if self.isPlaying {
            DispatchQueue.main.async {
                let attributedString = highlighterTool.highlight(text: defaultValue ?? "")
                uiView.setAttributed(attributedString)
            }
        } else {
            uiView.pause()
        }
    }
}

struct CodeEditor_Previews: PreviewProvider {
    static var previews: some View {
        CodeEditor(defaultValue: "")
    }
}
