//
//  ImageView.swift
//  ImageCaching
//
//  Created by Devansh Vyas on 12/04/25.
//

import SwiftUI

// Common Image View to load and show image
struct ImageView: View {
    // Required variables
    @StateObject var imageLoader = ImageLoader()
    var imgUrl: String
    let placeHolder = UIImage(systemName: "photo")!.withRenderingMode(.alwaysTemplate)
    var onImageLoad: ((CGFloat) -> Void)? = nil
    
    var body: some View {
        Image(uiImage: imageLoader.image ?? placeHolder)
            .resizable()
            .scaledToFit()
            .foregroundStyle(Color.gray)
            .onAppear {
                // Load image and store it's aspect ratio
                imageLoader.loadImage(imgUrl)
                if let ratio = imageLoader.aspectRatio {
                    onImageLoad?(ratio)
                }
            }
            .onDisappear {
                // Cancel loading image on changing view
                imageLoader.cancel()
            }
    }
}

#Preview {
    ImageView(imgUrl: "")
}
