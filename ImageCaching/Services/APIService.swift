//
//  APIService.swift
//  ImageCaching
//
//  Created by Devansh Vyas on 11/04/25.
//

import Foundation
import Combine

// APIService - For networking calls
class APIService {
    static let shared = APIService()
    
    // To fetch the images from flicker API and covert it into url strings
    func getFlickerImages() -> AnyPublisher<[String], Error> {
        let url = URL(string: "https://api.flickr.com/services/feeds/photos_public.gne?format=json&tags=nature&nojsoncallback=1")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: FlickrResponse.self, decoder: JSONDecoder())
            .map({ $0.items.compactMap(\.media.m) })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // To fetch the images from unsplash API with Pagination and covert it into UnSplashImageResult model
    func getUnsplashImages(page: Int) -> AnyPublisher<[UnSplashImageResult], Error> {
        let url = URL(string: "https://api.unsplash.com/search/photos?query=nature&page=\(page)&per_page=30&client_id=MfRQWvRBm-b3x6z1drf_gisygDNFhG1BJvvvgTFMIA4")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: UnSplashResponse.self, decoder: JSONDecoder())
            .map({ $0.results })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
