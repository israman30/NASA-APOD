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
            ScrollView {
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
}

#Preview {
    ContentView()
}

