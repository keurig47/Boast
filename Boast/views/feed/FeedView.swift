//
//  FeedView.swift
//  Boast
//
//  Created by David Keimig on 8/20/20.
//

import SwiftUI

struct ScrollOffsetPreferenceKey: PreferenceKey {
    typealias Value = [CGFloat]
    
    static var defaultValue: [CGFloat] = [0]
    
    static func reduce(value: inout [CGFloat], nextValue: () -> [CGFloat]) {
        value.append(contentsOf: nextValue())
    }
}

struct FeedView: View {
    @State var scrollPosition: Int = 0
    @EnvironmentObject var store: Store
    @EnvironmentObject var authState: AuthStateProvider
    
    private func calculateContentOffset(fromOutsideProxy outsideProxy: GeometryProxy, insideProxy: GeometryProxy) -> CGFloat {
        return outsideProxy.frame(in: .global).minY - insideProxy.frame(in: .global).minY
    }
    
    var body: some View {
        VStack {
            if !self.store.feed.isEmpty {
                GeometryReader { outer in
                    ScrollView(showsIndicators: false) {
                        VStack {
//                            GeometryReader { inner in
//                                VStack {}
//                                    .preference(
//                                        key: ScrollOffsetPreferenceKey.self,
//                                        value: [self.calculateContentOffset(fromOutsideProxy: outer, insideProxy: inner)]
//                                    )
//                            }
                            ForEach(0..<self.store.feed.count) { index in
                                Post(data: self.store.feed[index], user: authState.currentUser?.uid, isPlaying: true)
                            }
//                        }
                    }
//                    .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
//                        self.scrollPosition = Int(value[0] / 400)
//                    }
                }
                }
            } else {
                AddFriendsView()
            }
        }
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
