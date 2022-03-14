// Copyright (C) 2022 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import Foundation

public enum APIError: Error, CustomStringConvertible {
    case empty
    case invalidUrl
    case decodingError
    
    public var description: String {
        switch self {
            case .empty: return "Query must contain at least one search term"
            case .invalidUrl: return "Invalid url"
            case .decodingError: return "Decoding error"
        }
    }
}

public protocol APIClientProtocol {
    static func fetchBooks(query: BooksQuery) async throws -> [Book]
}

public struct APIClient {
    static let decoder = JSONDecoder()
    
    public static func fetchBooks(query: BooksQuery) async throws -> [Book] {
        guard let url = try query.url else {
            throw APIError.invalidUrl
        }
        
        // TODO: Add do...catch block for more detailed error handling.
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do {
            let result = try decoder.decode(BooksQueryResult.self, from: data)
            return result.books.compactMap { $0 }
        } catch {
            showError(error, data: data)
            throw APIError.decodingError
        }
    }
}

private extension APIClient {
    
    private static func showError(_ error: Error, data: Data) {
        print(String(data: data, encoding: .utf8) ??
              "Unable to decode data as \(String.Encoding.utf8)")
        print(error)
    }
}
