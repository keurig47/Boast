//
//  AvatarIcon.swift
//  Boast
//
//  Created by David Keimig on 8/24/20.
//

import SwiftUI

struct AvatarIcon: View {
    var body: some View {
        AsyncImage(url: "https://i.pinimg.com/originals/51/f6/fb/51f6fb256629fc755b8870c801092942.png")
            .padding(.top, 3.0)
            .aspectRatio(contentMode: .fit)
            .frame(width: 100, height: 100, alignment: .top)
    }
}

struct AvatarIcon_Previews: PreviewProvider {
    static var previews: some View {
        AvatarIcon()
    }
}
