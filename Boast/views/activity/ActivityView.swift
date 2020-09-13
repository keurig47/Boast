//
//  ActivityView.swift
//  Boast
//
//  Created by David Keimig on 9/8/20.
//

import SwiftUI

struct ActivityView: View {
    var body: some View {
        NavigationView {
            Text("No activity yet!")
                .navigationTitle("Activity")
        }
    }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView()
    }
}
