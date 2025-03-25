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

@MainActor
final class APODViewModel: APODViewModelProtocol {
    @Published var apod: APOD?
    @Published var error: NetworkError?
    @Published var currentDate = Date.now
    
    private let savedKey = "savedData"
    private let networkManger: NetworkManager
    
    init(networkManger: NetworkManager) {
        self.networkManger = networkManger
    }
    
    func fetchAPOD(with date: String?) async {
        print("input date: \(date ?? "nada")")
        do {
            self.apod = try await networkManger.fetch(date: date)
            self.save()
        } catch {
            self.error = .unknownError(statusCode: 0)
        }
    }
    
    func retrieved() {
        if let data = UserDefaults.standard.data(forKey: savedKey) {
            if let decoded = try? JSONDecoder().decode(APOD.self, from: data) {
                print(decoded, "<-- decoded")
                self.apod = decoded
                print(apod.debugDescription, "<-- decoded data")
            }
        }
    }
    
    func save() {
        if let encodedData = try? JSONEncoder().encode(apod) {
            UserDefaults.standard.set(encodedData, forKey: savedKey)
            print("data saved")
        }
    }
}
