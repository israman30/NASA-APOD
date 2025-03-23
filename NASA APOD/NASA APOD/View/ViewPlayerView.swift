//
//  ViewPlayerView.swift
//  NASA APOD
//
//  Created by Israel Manzo on 3/22/25.
//

import SwiftUI
import WebKit

struct ViewPlayerView: View {
    let videoURLString: String?
    
    var body: some View {
        VStack {
            VideoPlayerView(videoURLString: videoURLString)
                .scaledToFit()
        }
    }
}

struct VideoPlayerView: UIViewRepresentable {
    
    let videoURLString: String?
    
    func makeUIView(context: Context) -> WKWebView {
        WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let videoURLString = videoURLString,
              let urlString = URL(string: videoURLString) else { return }
        uiView.scrollView.isScrollEnabled = false
        let request = URLRequest(url: urlString)
        uiView.load(request)
    }
}

#Preview {
    ViewPlayerView(videoURLString: "https://www.youtube.com/embed/CC7OJ7gFLvE?rel=0")
}
