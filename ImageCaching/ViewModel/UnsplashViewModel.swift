//
//  FlickrViewModel.swift
//  ImageCaching
//
//  Created by Devansh Vyas on 11/04/25.
//

import UIKit
import Combine

/* UnsplashViewModel - Used as middleware to get the data and publish as common ImageModel
 In unsplash API we are getting height and width of image
 so we have added two variables leftItems and rightItems for both columns
 to be shown in view just like Pinterest views
 */
class UnsplashViewModel: ObservableObject {
    // Published Variables
    @Published var leftItems: [ImageModel] = []
    @Published var rightItems: [ImageModel] = []
    @Published var errorMessage: String?
    private var page: Int = 1
    private var leftHeight: Double = 0
    private var rightHeight: Double = 0
    private var cancellable = Set<AnyCancellable>()
    
    // To get the images from API and filter as per the height
    func getImages() {
        APIService.shared.getUnsplashImages(page: page)
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] imageResult in
                guard let `self` = self else { return }
                for item in imageResult {
                    let model = ImageModel(url: item.urls.small)
                    let div = Double(item.width/400)
                    let height = Double(item.height)/div
                    if self.leftHeight > (self.rightHeight) {
                        self.rightHeight += height
                        self.rightItems.append(model)
                    } else {
                        self.leftHeight += height
                        self.leftItems.append(model)
                    }
                }
            }
            .store(in: &cancellable)
    }
    
    // Paginate to get the next set of data
    func paginate() {
        page += 1
        getImages()
    }
}
