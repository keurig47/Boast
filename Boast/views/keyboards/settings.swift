//
//  languages.swift
//  Boast
//
//  Created by David Keimig on 10/14/20.
//

import SwiftUI
import Combine

struct SettingsKeyboard: View {
    @EnvironmentObject var delegate: KeyboardDelegate

    var body: some View {
        VStack {
            Text("Font Size")
        }
    }
}
