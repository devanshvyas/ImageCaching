//
//  FlickrImagesView.swift
//  ImageCaching
//
//  Created by Devansh Vyas on 11/04/25.
//

import SwiftUI
import Combine

// UnsplashImagesView - To show all the images as Pinterest like View
struct UnsplashImagesView: View {
    // Required variables
    var gridItems: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    @StateObject var viewModel = UnsplashViewModel()
    @StateObject var imageLoader = ImageLoader()
    @State private var showAlert = false
    @State private var isLoading = false
    
    
    var body: some View {
        NavigationView {
            ScrollView {
                HStack(alignment: .top, spacing: 10) {
                    LazyVStack(spacing: 10) {
                        ForEach(viewModel.leftItems) { item in
                            itemView(for: item)
                        }
                    }
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.rightItems) { item in
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
            .navigationTitle(Text("Unsplash Images"))
        }
        .onAppear {
            // Fetch images on appear
            viewModel.getImages()
        }
    }
    
    // Individual image view
    func itemView(for item: ImageModel) -> some View {
        ImageView(imgUrl: item.url)
            .clipped()
            .cornerRadius(8)
            .onAppear {
                // Pagination on appear of last item
                if item.url == viewModel.leftItems.last?.url, !isLoading {
                    self.viewModel.paginate()
                }
            }
    }
}


#Preview {
    UnsplashImagesView()
}

