//
//  ImageCache.swift
//  NASA APOD
//
//  Created by Israel Manzo on 3/21/25.
//

import SwiftUI

/// Image Cache component
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
                    .task {
                        await loadImage()
                    }
            }
        }
    }
    
    private func loadImage() async {
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
