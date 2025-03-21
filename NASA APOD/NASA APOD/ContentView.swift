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
            VStack {
                Text(viewModel.apod?.title ?? "nothing")
                    .navigationTitle("NASA APOD")
                    .task {
                        await viewModel.fetchAPOD()
                    }
                Text(viewModel.apod?.explanation ?? "nothing")
                Text(viewModel.apod?.date ?? "nothing")
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}

class APODViewModel: ObservableObject {
    @Published var apod: APOD?
    @Published var error: NetworkError?
    
    private let networkManger: NetworkManager
    
    init(networkManger: NetworkManager) {
        self.networkManger = networkManger
    }
    
    func fetchAPOD() async {
        do {
            self.apod = try await networkManger.fetch(from: Constant.url)
        } catch {
            self.error = .unknownError(statusCode: 0)
        }
    }
}
