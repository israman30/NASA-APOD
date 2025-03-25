//
//  APODViewModel.swift
//  NASA APOD
//
//  Created by Israel Manzo on 3/20/25.
//

import SwiftUI

/// Protocol `APODViewModelProtocol` defines the functionality for fetching data.
/// - Parameter date: The date used for fetching data. Defaults to the current date, but can be set to fetch data for a specific date as needed.
protocol APODViewModelProtocol: ObservableObject {
    func fetchAPOD(with date: String?) async
}

/// `LocalStorageProtocol` defines methods for saving and retrieving data from local storage.
protocol LocalStorageProtocol {
    func save() async
    func retrieve() async
}

@MainActor
final class APODViewModel: APODViewModelProtocol, LocalStorageProtocol {
    @Published var apod: APOD?
    @Published var error: NetworkError?
    @Published var currentDate = Date.now
    
    private let savedKey = "savedData"
    private let networkManger: NetworkManager
    
    init(networkManger: NetworkManager) {
        self.networkManger = networkManger
    }
    
    func fetchAPOD(with date: String?) async {
        print("DEBUG: \(date ?? "no date found")")
        do {
            self.apod = try await networkManger.fetch(date: date)
            self.save()
        } catch {
            self.error = .unknownError(statusCode: 0)
        }
    }
    
    /// `Retrieves` and `decodes` data from local storage, assigning it to the `apod` object.
    func retrieve() {
        if let data = UserDefaults.standard.data(forKey: savedKey) {
            if let decoded = try? JSONDecoder().decode(APOD.self, from: data) {
                self.apod = decoded
                print(apod.debugDescription, "<-- DEBUG: decoded data")
            }
        }
    }
    
    /// `Encode` and `save` data to local storage using a specified key
    func save() {
        if let encodedData = try? JSONEncoder().encode(apod) {
            UserDefaults.standard.set(encodedData, forKey: savedKey)
            print("DEBUG: data saved")
        }
    }
}
