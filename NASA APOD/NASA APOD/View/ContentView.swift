//
//  ContentView.swift
//  NASA APOD
//
//  Created by Israel Manzo on 3/20/25.
//
// https://api.nasa.gov/planetary/apod?api_key=tXNvkBhAvgNMi8HR7pJX3PXbxUx3df95cMwiT2g0

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = APODViewModel(networkManger: NetworkManager())
    @State var currentDate = Date.now
    
    var body: some View {
        NavigationView {
            ScrollView {
                DatePicker(selection: $currentDate, displayedComponents: .date) {
                    Text("\(currentDate.formatted(.iso8601.year().month().day()))")
                }
                .onChange(of: currentDate) { newValue in
                    self.currentDate = newValue
                    Task {
                        await viewModel.fetchAPOD(with: currentDate.formatted(.iso8601.year().month().day()))
                    }
                }
                .task {
                    await viewModel.fetchAPOD(with: "2021-10-11")
                }
                
                mainBody
            }
        }
    }
    
    private var mainBody: some View {
        VStack {
            if viewModel.apod?.hdurl == nil && viewModel.apod?.media_type == "image" {
                if let urlString = viewModel.apod?.hdurl, let url = URL(string: urlString) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        case .empty:
                            Image(systemName: "photo.artframe")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        case .failure(_):
                            Image(systemName: "photo.artframe")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        @unknown default:
                            Image(systemName: "photo.artframe")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                }
            } else {
                ViewPlayerView(videoURLString: viewModel.apod?.url)
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
    }
}

#Preview {
    ContentView()
}

