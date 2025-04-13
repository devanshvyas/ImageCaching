//
//  UnsplashModels.swift
//  ImageCaching
//
//  Created by Devansh Vyas on 12/04/25.
//

import Foundation

// UnSplash Models to decode fron response data

// UnSplashResponse
struct UnSplashResponse: Decodable {
    let total: Int
    let totalPages: Int
    let results: [UnSplashImageResult]

    private enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
}

// UnSplashImageResult
struct UnSplashImageResult: Decodable {
    let id: String
    let width: Int
    let height: Int
    let urls: UnSplashImageURLs
}

// UnSplashImageURLs
struct UnSplashImageURLs: Decodable {
    let small: String
}
