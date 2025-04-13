//
//  TabView.swift
//  ImageCaching
//
//  Created by Devansh Vyas on 11/04/25.
//

import SwiftUI

// TabBarView - to provide Flickr and Unsplash images
struct TabBarView: View {
    var body: some View {
        TabView {
            Tab("Flickr", systemImage: "person.crop.circle.fill") {
                FlickrImagesView()
            }
            
            Tab("Unsplash", systemImage: "person.crop.circle.fill") {
                UnsplashImagesView()
            }
        }
    }
}

#Preview {
    TabBarView()
}
