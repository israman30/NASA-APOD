//
//  ContentView.swift
//  NASA APOD
//
//  Created by Israel Manzo on 3/20/25.
//

import SwiftUI

// https://api.nasa.gov/planetary/apod?api_key=tXNvkBhAvgNMi8HR7pJX3PXbxUx3df95cMwiT2g0

struct ContentView: View {
    
    @StateObject var viewModel = APODViewModel(networkManger: NetworkManager())
    
    var body: some View {
        NavigationView {
            VStack {
                if let urlString = viewModel.apod?.hdurl, let url = URL(string: urlString) {
                    CacheAsyncImage(url: url)
                }
                
                Text(viewModel.apod?.title ?? "nothing")
                    .font(.title2)
                    
                Text(viewModel.apod?.explanation ?? "nothing")
                    .font(.body)
                
                HStack {
                    Spacer()
                    Text(viewModel.apod?.date ?? "nothing")
                        .font(.body)
                }
                Spacer()
            }
            .navigationTitle("NASA APOD")
            .padding()
            .task {
                await viewModel.fetchAPOD()
            }
        }
    }
}

#Preview {
    ContentView()
}

// Image Cache compoenent
class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSURL, UIImage>()
    
    private init() {}
    
    func image(for url: NSURL) -> UIImage? {
        return cache.object(forKey: url)
    }
    
    func insertImage(_ image: UIImage?, for url: NSURL) {
        guard let image = image else { return }
        cache.setObject(image, forKey: url)
    }
}

struct CacheAsyncImage: View {
    let url: URL
    @State private var image: Image? = nil
    
    var body: some View {
        VStack {
            if let image = image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                ProgressView()
                    .onAppear {
                        loadImage()
                    }
            }
        }
    }
    
    private func loadImage() {
        let nsURL = url as NSURL
        if let cachedImage = ImageCache.shared.image(for: nsURL) {
            self.image = Image(uiImage: cachedImage)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let uiImage = UIImage(data: data) else { return }
            ImageCache.shared.insertImage(uiImage, for: nsURL)
            DispatchQueue.main.async {
                self.image = Image(uiImage: uiImage)
            }
        }
        task.resume()
    }
}
