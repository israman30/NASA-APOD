//
//  APODViewModel.swift
//  NASA APOD
//
//  Created by Israel Manzo on 3/20/25.
//

import SwiftUI

protocol APODViewModelProtocol: ObservableObject {
    func fetchAPOD(with date: String?) async
}

@MainActor
final class APODViewModel: APODViewModelProtocol {
    @Published var apod: APOD?
    @Published var error: NetworkError?
    
    private let networkManger: NetworkManager
    
    init(networkManger: NetworkManager) {
        self.networkManger = networkManger
    }
    
    func fetchAPOD(with date: String?) async {
        do {
            self.apod = try await networkManger.fetch(date: date)
        } catch {
            self.error = .unknownError(statusCode: 0)
        }
    }
}
