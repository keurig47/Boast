//
//  languages.swift
//  Boast
//
//  Created by David Keimig on 10/14/20.
//

import SwiftUI
import UIKit
import Combine

struct ThemesKeyboard: View {
    @EnvironmentObject var delegate: KeyboardDelegate
    let columns = [
        GridItem(.adaptive(minimum: 120), spacing: 1.0)
    ]
    
    func getColor(item: Theme) -> Color {
        let keyword = item.themeDict["hljs-keyword"]
        if keyword != nil {
            let nsColor = keyword!["NSColor"]
            if nsColor != nil {
                return Color(nsColor as! UIColor)
            }
        }
        return Color.blue
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 1) {
                ForEach(highlighterTool.themes().sorted { $0.themeName.lowercased() < $1.themeName.lowercased() }, id: \.self.themeName) { item in
                    Button(action: {
                        self.delegate.theme = item.themeName
                    }, label: {
                        Text(item.themeName.capitalized)
                            .font(.custom((item.codeFont as UIFont).familyName , size: 14))
                            .truncationMode(.tail)
                            .lineLimit(1)
                            .frame(minWidth: 0, idealWidth: 50, maxWidth: .infinity, minHeight: 0, idealHeight: 50, maxHeight: .infinity, alignment: .center)
                            .padding(.all, 12)
                            .foregroundColor(self.getColor(item: item))
                            .background(Color((item.themeBackgroundColor) as UIColor))
                    })
                }
            }
            .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
        }
    }
}
