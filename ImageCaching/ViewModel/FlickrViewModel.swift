//
//  FlickrViewModel.swift
//  ImageCaching
//
//  Created by Devansh Vyas on 11/04/25.
//

import UIKit
import Combine

// FlickrViewModel - Used as middleware to get the data and publish as common ImageModel
class FlickrViewModel: ObservableObject {
    // Published variables
    @Published var flickrItems: [ImageModel] = []
    @Published var errorMessage: String?
    private var cancellable = Set<AnyCancellable>()
    
    // To fetch and assign the images
    func getImages() {
        APIService.shared.getFlickerImages()
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] urls in
                self?.flickrItems = urls.compactMap({ ImageModel(url: $0) })
            }
            .store(in: &cancellable)
    }
}
