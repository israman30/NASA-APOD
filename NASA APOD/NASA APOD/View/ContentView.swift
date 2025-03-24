//
//  ContentView.swift
//  NASA APOD
//
//  Created by Israel Manzo on 3/20/25.
//
// https://api.nasa.gov/planetary/apod?api_key=tXNvkBhAvgNMi8HR7pJX3PXbxUx3df95cMwiT2g0

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = APODViewModel(networkManger: NetworkManager())
    
    var body: some View {
        NavigationView {
            ScrollView {
                DatePicker(selection: $viewModel.currentDate, displayedComponents: .date) {
                    Text("Select Date")
                        .font(.body)
                }
                .padding(.horizontal)
                .onChange(of: viewModel.currentDate) { newValue in
                    self.viewModel.currentDate = newValue
                    Task {
                        await fetchAPOD(date: viewModel.currentDate.formatted(.iso8601.year().month().day()))
                    }
                }
                .task {
                    await fetchAPOD(date: viewModel.apod?.date ?? "")
                }
                
                mainBody
            }
        }
    }
    
    /// use` fetchAPOD()` for call viewModel object when View `appears` and `updates`
    private func fetchAPOD(date: String) async {
        await viewModel.fetchAPOD(with: date)
    }
    
    private var mainBody: some View {
        /// Displays media content `(image, video, or placeholder)` based on the API response.
        VStack {
            if viewModel.apod?.hdurl != nil && viewModel.apod?.media_type == "image" {
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
            } else if viewModel.apod?.url == nil && viewModel.apod?.media_type == "other" {
                Text("No image available")
                    .font(.caption)
            } else {
                ViewPlayerView(videoURLString: viewModel.apod?.url)
            }
            /// Section displaying text based on API response
            VStack {
                Text(viewModel.apod?.title ?? "not title")
                    .font(.title2)
                
                Text(viewModel.apod?.explanation ?? "not explanation")
                    .font(.body)
                
                HStack {
                    Spacer()
                    Text("Current date: \(viewModel.apod?.date ?? "not date")")
                        .font(.body)
                }
                Spacer()
            }
            .padding()
        }
        .navigationTitle("NASA APOD")
    }
}

#Preview {
    ContentView()
}

