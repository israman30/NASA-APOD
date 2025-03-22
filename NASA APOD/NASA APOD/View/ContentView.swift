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
    @State var currentDate = Date.now
    
    var body: some View {
        NavigationView {
            ScrollView {
                
                DatePicker(selection: $currentDate, displayedComponents: .date) {
                    Text("\(currentDate)")
                }
                
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
                    await viewModel.fetchAPOD(with: "2025-03-21")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

