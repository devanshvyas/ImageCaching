//
//  FlickrModels.swift
//  ImageCaching
//
//  Created by Devansh Vyas on 11/04/25.
//

import Foundation

// Flicker Models to decode fron response data

// FlickrResponse
struct FlickrResponse: Decodable {
    let items: [FlickrItem]
}

// FlickrItem
struct FlickrItem: Decodable {
    let media: FlickrMedia
}

// FlickrMedia
struct FlickrMedia: Decodable {
    let m: String
}

// Common model to be used in both Flickr and Unsplash APIs
// ImageModel
struct ImageModel: Identifiable {
    var id = UUID()
    var url: String
    var aspectRatio: CGFloat = 1.0
}
