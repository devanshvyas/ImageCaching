//
//  ImageLoader.swift
//  ImageCaching
//
//  Created by Devansh Vyas on 12/04/25.
//

import UIKit
import Combine

// ImageLoader - To get the image from Cache if it's not available then get it from remote
class ImageLoader: ObservableObject {
    // Published variables
    @Published var isLoaded: Bool = false
    @Published var image: UIImage?
    @Published var aspectRatio: CGFloat?
    private var cancellable: AnyCancellable?
    
    // To assign the image from remote or cache
    func loadImage(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        if let img = CacheService.shared.getImage(from: url) {
            isLoaded = true
            image = img
        } else {
            loadImageFromRemote(url)
        }
    }
    
    // To fetch the image data from remote
    private func loadImageFromRemote(_ url: URL) {
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] _ in
                self?.isLoaded = true
            }, receiveValue: { [weak self] image in
                self?.isLoaded = true
                guard let img = image else { return }
                self?.image = img
                self?.aspectRatio = img.size.width != 0 ? img.size.height / img.size.width : 1
            })
    }
    
    // Cancel fetching data
    func cancel() {
        cancellable?.cancel()
    }
}
