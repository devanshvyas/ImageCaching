//
//  CacheService.swift
//  ImageCaching
//
//  Created by Devansh Vyas on 12/04/25.
//

import UIKit

// CacheService - To cache the images with url as key
class CacheService {
    // Variable Declaration
    static let shared = CacheService()
    private let cache = NSCache<NSURL, UIImage>()
    
    // Get Image from Cache
    func getImage(from url: URL) -> UIImage? {
        cache.object(forKey: url as NSURL)
    }
    
    // Add Image to cache
    func addImageToCache(url: URL, image: UIImage?) {
        guard let img = image else { return }
        cache.setObject(img, forKey: url as NSURL)
    }
}
