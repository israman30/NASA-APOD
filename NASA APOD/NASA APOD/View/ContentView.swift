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
    @State var newDate = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                
                DatePicker(selection: $currentDate, displayedComponents: .date) {
                    Text("\(currentDate.formatted(.iso8601.year().month().day()))")
                }
                .onChange(of: currentDate) { newValue in
                    print("\(currentDate) -> \(newValue)")
                    self.currentDate = newValue
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
                    await viewModel.fetchAPOD(with: currentDate.formatted(.iso8601.year().month().day()))
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

