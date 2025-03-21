//
//  NetworkManager.swift
//  NASA APOD
//
//  Created by Israel Manzo on 3/20/25.
//

import SwiftUI

struct Constant {
    static var apiKey: String {
        "tXNvkBhAvgNMi8HR7pJX3PXbxUx3df95cMwiT2g0"
    }
    
    static var baseURL: String {
        "https://api.nasa.gov/planetary/apod?"
    }
    
    static var url: URL {
        guard let url = URL(string: "\(baseURL)api_key=\(apiKey)") else {
            fatalError("Invalid URL")
        }
        return url
    }
}

enum NetworkError: Error {
    case invalidateResponse
    case decondingFailed
    case clientError(statusCode: Int)
    case serverError(statusCode: Int)
    case unknownError(statusCode: Int)
}

extension NetworkError {
    var errorDescription: String? {
        switch self {
        case .invalidateResponse:
            return "Invalid response"
        case .decondingFailed:
            return "Decoding failed"
        case .clientError(statusCode: let code):
            return "Client error: \(code)"
        case .serverError(statusCode: let code):
            return "Server error: \(code)"
        case .unknownError:
            return "Unknown error"
        }
    }
}

protocol NetworkManagerProtocol {
    func fetch<T: Decodable>(from endpoint: URL) async throws -> T
}

class NetworkManager: NetworkManagerProtocol {
    func fetch<T: Decodable>(from endpoint: URL) async throws -> T {
        let (data, response) = try await URLSession.shared.data(from: endpoint)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidateResponse
        }
        
        try invalid(httpResponse)
        
        do {
            let decode = JSONDecoder()
            return try decode.decode(T.self, from: data)
        } catch {
            throw NetworkError.decondingFailed
        }
    }
    
    func invalid(_ response: HTTPURLResponse) throws {
        switch response.statusCode {
        case 200...399:
            return
        case 400...599:
            throw NetworkError.clientError(statusCode: response.statusCode)
        case 600...799:
            throw NetworkError.serverError(statusCode: response.statusCode)
        default:
            throw NetworkError.unknownError(statusCode: response.statusCode)
        }
    }
}
