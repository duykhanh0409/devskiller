//
//  NetworkManager.swift
//  Devskiller
//
//  Created by Khanh Nguyen on 31/8/25.
//  Copyright © 2025 Mindera. All rights reserved.
//

import Foundation
import Combine

class NetworkingManager {
    
    enum NetworkingError: Equatable, LocalizedError {
        case invalidURL
        case badResponse(statusCode: Int)
        case decodingError(String)
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "The provided URL is invalid."
            case .badResponse(let code):
                return "Bad response from server. Status code: \(code)"
            case .decodingError(let message):
                return "Failed to decode response: \(message)"
            case .unknown:
                return "An unknown error occurred."
            }
        }
    }
    
    // MARK: - Simple fetch method
    static func fetchData(from urlString: String) -> AnyPublisher<Data, Error> {
        guard let url = URL(string: urlString) else {
            return Fail(error: NetworkingError.invalidURL).eraseToAnyPublisher()
        }
        
        print("🌐 Fetching data from: \(urlString)")
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { element -> Data in
                guard let response = element.response as? HTTPURLResponse else {
                    throw NetworkingError.badResponse(statusCode: -1)
                }
                
                print("📡 Response status code: \(response.statusCode)")
                
                guard 200..<300 ~= response.statusCode else {
                    throw NetworkingError.badResponse(statusCode: response.statusCode)
                }
                
                print("✅ Data received: \(element.data.count) bytes")
                return element.data
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Generic fetch method for decoding
    static func fetch<T: Codable>(_ type: T.Type, from urlString: String) -> AnyPublisher<T, Error> {
        return fetchData(from: urlString)
            .tryMap { data -> T in
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(T.self, from: data)
                    print("✅ Successfully decoded \(T.self)")
                    return result
                } catch {
                    print("❌ Decoding error: \(error)")
                    print("📄 Raw data: \(String(data: data, encoding: .utf8) ?? "Unable to convert to string")")
                    throw NetworkingError.decodingError(error.localizedDescription)
                }
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Handle completion
    static func handleCompletion(_ completion: Subscribers.Completion<Error>) -> String? {
        switch completion {
        case .finished:
            return nil
        case .failure(let error):
            print("❌ Network error: \(error)")
            return (error as? NetworkingError)?.localizedDescription ?? error.localizedDescription
        }
    }
}
