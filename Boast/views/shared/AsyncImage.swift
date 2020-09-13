//
//  AsyncImage.swift
//  Boast
//
//  Created by David Keimig on 8/20/20.
//

import SwiftUI
import Combine
import Foundation

struct AsyncImage: View {
    @ObservedObject private var loader: ImageLoader
    
    init(url: String) {
        let imgUrl: URL = URL(string: url)!
        loader = ImageLoader(url: imgUrl)
    }
    
    private var image: some View {
        Group {
            if loader.image != nil {
                Image(uiImage: loader.image!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                ProgressView()
            }
        }
    }
    
    var body: some View {
        image
            .onAppear(perform: loader.load)
            .onDisappear(perform: loader.cancel)
    }
}

struct AsyncImage_Previews: PreviewProvider {
    static var previews: some View {
        AsyncImage(url: "https://i.pinimg.com/originals/51/f6/fb/51f6fb256629fc755b8870c801092942.png")
    }
}

class ImageLoader: ObservableObject {
    
    @Published var image: UIImage?
    private let url: URL
    private var cancellable: AnyCancellable?

    init(url: URL) {
        self.url = url
    }
    
    deinit {
        cancellable?.cancel()
    }

    func load() {
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
    }
    
    func cancel() {
        cancellable?.cancel()
    }
}
