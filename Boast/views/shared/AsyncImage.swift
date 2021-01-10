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
    var url: String
    @StateObject private var loader: ImageLoader = ImageLoader()
    
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
    
    func fetchImage() {
        self.loader.load(url: URL(string: self.url)!)
    }
    
    var body: some View {
        image
            .onAppear(perform: self.fetchImage)
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
    private var url: URL = URL(string: "https://i.pinimg.com/originals/51/f6/fb/51f6fb256629fc755b8870c801092942.png")!
    private var cancellable: AnyCancellable?
    
    deinit {
        cancellable?.cancel()
    }

    func load(url: URL) {
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
