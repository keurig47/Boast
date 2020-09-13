//
//  CodeEditor.swift
//  Boast
//
//  Created by David Keimig on 9/1/20.
//

import SwiftUI

struct CodeEditor: View {
    @State private var loading: Bool = true
    @StateObject private var kguard = KeyboardGuardian()
    @EnvironmentObject var store: Store
    @EnvironmentObject var editorState: EditorState
    
    var defaultValue: String = ""
    var options: [String: Any] = [:]
    var isUserInteractionEnabled: Bool = true
    var theme: String?
    var syntax: String?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                WebView(
                    kguard: kguard,
                    defaultValue: defaultValue,
                    options: options,
                    isUserInteractionEnabled: isUserInteractionEnabled,
                    theme: theme,
                    syntax: syntax,
                    loading: $loading
                )
                .environmentObject(editorState)
                if loading {
                    ProgressView()
                        .scaleEffect(1.5, anchor: .center)
                }
                if !kguard.keyboardIsHidden && (options["readOnly"] == nil) {
                    AccessoryBar(
                        geometry: geometry.frame(in: .local),
                        keyboardRect: $kguard.keyboardRect,
                        kguard: kguard)
                        .position(x: geometry.frame(in: .local).midX, y:   (kguard.keyboardRect.minY - (geometry.frame(in: .global).minY - geometry.safeAreaInsets.top + 22)))
                        .ignoresSafeArea()
                }
            }
        }
        .onAppear {
            kguard.addObserver()
        }
        .onDisappear {
            kguard.removeObserver()
        }
    }
}

struct CodeEditor_Previews: PreviewProvider {
    static var previews: some View {
        CodeEditor()
    }
}
