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
                    viewModel.retrieved()
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
                if let title = viewModel.apod?.title,
                   let savedTitle = viewModel.savedData?.title {
                    Text(savedTitle.isEmpty ? title : savedTitle)
                        .font(.title2)
                }
                
                if let explanation = viewModel.apod?.explanation,
                   let savedExplanation = viewModel.savedData?.explanation {
                    Text(savedExplanation.isEmpty ? explanation : savedExplanation)
                        .font(.body)
                }
                
                HStack {
                    Spacer()
                    if let date = viewModel.apod?.date, let saveDate = viewModel.savedData?.date {
                        Text("Current date: \(saveDate.isEmpty ? date : saveDate)")
                            .font(.body)
                    }
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

