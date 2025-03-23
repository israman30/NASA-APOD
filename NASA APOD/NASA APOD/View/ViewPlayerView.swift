//
//  ViewPlayerView.swift
//  NASA APOD
//
//  Created by Israel Manzo on 3/22/25.
//

import SwiftUI
import AVKit

struct ViewPlayerView: View {
    let videoURLString: String?
    
    var body: some View {
        if let videoString = videoURLString, let url = URL(string: videoString)  {
            VideoPlayer(player: AVPlayer(url: url))
                .scaledToFit()
        }
    }
}


#Preview {
    ViewPlayerView(videoURLString: "https://www.youtube.com/embed/CC7OJ7gFLvE?rel=0")
}
