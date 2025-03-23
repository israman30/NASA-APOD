//
//  NetworkManager.swift
//  NASA APOD
//
//  Created by Israel Manzo on 3/20/25.
//

import SwiftUI

struct URLScheme {
    /// API key should be hidden
    static var apiKey: String {
        "tXNvkBhAvgNMi8HR7pJX3PXbxUx3df95cMwiT2g0"
    }
}

enum NetworkError: Error {
    case invalidateResponse
    case decondingFailed
    case clientError(statusCode: Int)
    case serverError(statusCode: Int)
    case unknownError(statusCode: Int)
    case invalidURL
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
        case .invalidURL:
            return "Invalid URL"
        }
    }
}

protocol NetworkManagerProtocol {
    func fetch<T: Decodable>(date: String?) async throws -> T
}

class NetworkManager: NetworkManagerProtocol {
    
    func fetch<T: Decodable>(date: String?) async throws -> T {
        let url = try await query(with: date)
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
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
    
    func query(with date: String? = nil) async throws -> URL {
        var request = URLComponents()
        request.scheme = "https"
        request.host = "api.nasa.gov"
        request.path = "/planetary/apod"
        request.queryItems = [URLQueryItem(name: "api_key", value: URLScheme.apiKey)]
        if let date = date {
            request.queryItems?.append(URLQueryItem(name: "date", value: date))
        }
        
        guard let url = request.url else {
            throw NetworkError.invalidURL
        }
        print("URL: \(url)")
        return url
    }
}
