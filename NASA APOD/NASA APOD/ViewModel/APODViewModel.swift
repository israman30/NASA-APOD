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
    
    private let networkManger: NetworkManager
    
    init(networkManger: NetworkManager) {
        self.networkManger = networkManger
    }
    
    func fetchAPOD(with date: String?) async {
        print("input date: \(date ?? "nada")")
        do {
            self.apod = try await networkManger.fetch(date: date)
        } catch {
            self.error = .unknownError(statusCode: 0)
        }
    }
}
