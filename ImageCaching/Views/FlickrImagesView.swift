//
//  FlickrImagesView.swift
//  ImageCaching
//
//  Created by Devansh Vyas on 11/04/25.
//

import SwiftUI
import Combine

// FlickrImagesView - To show all the images as Pinterest like View
struct FlickrImagesView: View {
    // Required variables
    var gridItems: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    @StateObject var viewModel = FlickrViewModel()
    @StateObject var imageLoader = ImageLoader()
    @State private var showAlert = false
    @State private var items: [ImageModel] = []
    
    // Main View
    var body: some View {
        let (leftCol, rightCol) = partitions(viewModel.flickrItems)
        NavigationView {
            ScrollView {
                HStack(alignment: .top, spacing: 12) {
                    LazyVStack(spacing: 12) {
                        ForEach(leftCol) { item in
                            itemView(for: item)
                        }
                    }
                    LazyVStack(spacing: 12) {
                        ForEach(rightCol) { item in
                            itemView(for: item)
                        }
                    }
                }
                .padding()
            }
            // Assign showAlert as errorMessage changes
            .onReceive(viewModel.$errorMessage, perform: { msg in
                showAlert = msg != nil
            })
            // To show error
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"),
                      message: Text(viewModel.errorMessage!),
                      dismissButton: .default(Text("OK"), action: {
                    viewModel.errorMessage = nil
                }))
            }
            .navigationTitle(Text("Flickr Images"))
        }
        .onAppear {
            // Fetch images on appear
            viewModel.getImages()
        }
    }
    
    // Individual image view as per aspect ratio
    func itemView(for item: ImageModel) -> some View {
        ImageView(imgUrl: item.url) { ratio in
            if let index = items.firstIndex(where: { $0.id == item.id }) {
                items[index].aspectRatio = ratio
            }
        }
        .clipped()
        .cornerRadius(8)
    }
    
    // To filter out two colums for view like pinterest
    func partitions(_ items: [ImageModel]) -> ([ImageModel], [ImageModel]) {
        var col1: [ImageModel] = []
        var col2: [ImageModel] = []
        var height1: CGFloat = 0
        var height2: CGFloat = 0
        
        for item in items {
            let estHeight = 1 / item.aspectRatio
            if height1 <= height2 {
                col1.append(item)
                height1 += estHeight
            } else {
                col2.append(item)
                height2 += estHeight
            }
        }
        return (col1, col2)
    }
}


#Preview {
    FlickrImagesView()
}

