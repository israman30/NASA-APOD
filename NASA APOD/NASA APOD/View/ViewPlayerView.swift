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
        if let videoURLString = videoURLString {
            ViewPlayerView(videoURLString: videoURLString)
        }
    }
}

struct VideoView: UIViewRepresentable {
    
    let videoURLString: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.configuration.allowsInlineMediaPlayback = true
        webView.configuration.mediaTypesRequiringUserActionForPlayback = []
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let url = URL(string: videoURLString) else { return }
        uiView.scrollView.isScrollEnabled = false
        uiView.load(URLRequest(url: url))
    }
}

#Preview {
    ViewPlayerView(videoURLString: "https://www.youtube.com/embed/CC7OJ7gFLvE?rel=0")
}
