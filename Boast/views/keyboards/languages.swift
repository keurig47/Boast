//
//  languages.swift
//  Boast
//
//  Created by David Keimig on 10/14/20.
//

import SwiftUI
import Combine

class KeyboardDelegate: ObservableObject {
    var onToggle: (() -> Void)?
    var onThemeChanged: ((_: String) -> Void)?
    var onLanguageChanged: ((_: String) -> Void)?
    var willChange = PassthroughSubject<KeyboardDelegate, Never>()
    var didChange = PassthroughSubject<KeyboardDelegate, Never>()
    
    @Published var fullscreen: Bool = false {
        didSet {
            didChange.send(self)
            if self.onToggle != nil && oldValue != fullscreen {
                self.onToggle!()
            }
        }
    }
    
    @Published var theme: String = "" {
        didSet {
            didChange.send(self)
            if self.onThemeChanged != nil {
                self.onThemeChanged!(self.theme)
            }
        }
    }
    
    @Published var language: String = "" {
        didSet {
            didChange.send(self)
            if self.onLanguageChanged != nil {
                self.onLanguageChanged!(self.language)
            }
        }
    }
    
    @Published var view: String = "languages" {
        didSet {
            didChange.send(self)
        }
    }
}

struct KeyboardRoot: View {
    @ObservedObject var delegate: KeyboardDelegate
    
    var body: some View {
        VStack {
            if (self.delegate.view == "languages") {
                LanguagesKeyboard()
                    .environmentObject(delegate)
            }
            else if (self.delegate.view == "themes") {
                ThemesKeyboard()
                    .environmentObject(delegate)
            }
            else{
                SettingsKeyboard()
                    .environmentObject(delegate)
            }
        }
    }
}

struct LanguagesKeyboard: View {
    @EnvironmentObject var delegate: KeyboardDelegate
    let columns = [
        GridItem(.adaptive(minimum: 120), spacing: 1.0)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 1) {
                ForEach(highlighterTool.languages().sorted { $0.lowercased() < $1.lowercased() }, id: \.self) { item in
                    Button(action: {
                        self.delegate.language = item
                    }, label: {
                        Text(item.capitalized)
                            .bold()
                            .truncationMode(.tail)
                            .lineLimit(1)
                            .frame(minWidth: 0, idealWidth: 50, maxWidth: .infinity, minHeight: 0, idealHeight: 50, maxHeight: .infinity, alignment: .center)
                            .padding(.all, 12)
                            .foregroundColor(.white)
                            .background(Color.accentColor)
                    })
                }
            }
            .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
        }
    }
}
