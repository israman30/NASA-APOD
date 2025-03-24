//
//  ContentView.swift
//  APOD
//
//  Created by Israel Manzo on 3/24/25.
//

import SwiftUI

struct APOD: Decodable {
    let date: String
    let explanation: String
    let hdurl: String?
    let media_type: String
    let title: String
    let url: String?
}

class NetworkManager {
    func fetchData() async throws -> APOD {
        guard let url = URL(string: "https://api.nasa.gov/planetary/apod?api_key=tXNvkBhAvgNMi8HR7pJX3PXbxUx3df95cMwiT2g0") else {
            fatalError()
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        return try JSONDecoder().decode(APOD.self, from: data)
    }
}

@MainActor
class ViewModel: ObservableObject {
    @Published var apod: APOD?
    
    private var networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func fetch() async {
        do {
            self.apod = try await networkManager.fetchData()
        } catch {
            print(error)
        }
    }
}

struct ContentView: View {
    @StateObject private var vm: ViewModel
    
    init() {
        self._vm = StateObject(wrappedValue: ViewModel(networkManager: NetworkManager()))
    }
    
    var body: some View {
        VStack {
            Text(vm.apod?.title ?? "nothing")
        }
        .task {
            await vm.fetch()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
