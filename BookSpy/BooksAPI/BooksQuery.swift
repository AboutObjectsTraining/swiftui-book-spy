// Copyright (C) 2022 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import Foundation

public extension String {
    static let space = " "
    static let plus = "+"
    static let ampersand = "&"
}

public protocol QueryProtocol {
    var media: String { get }
    var explicit: Bool { get }
    var country: String { get }
    var fetchLimit: Int { get }
    var fetchOffset: Int { get }
    var searchTerms: [String] { get }
    
    var queryString: String? { get }
    var url: URL? { get throws }
    
    init(searchTerms: [String], offset: Int)
}

public struct BooksQuery: QueryProtocol {
    static let searchUrlString = "https://itunes.apple.com/search"
    public let media = "ebook"
    public let explicit = false
    public var country = "us"
    public var fetchLimit: Int = 25
    public var fetchOffset: Int = 0
    public var searchTerms: [String]
    
    public var searchTermsString: String {
        searchTerms.joined(separator: String.plus)
    }
    
    public var queryString: String? {
        queryParameters
            .joined(separator: String.ampersand)
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
    
    public var queryParameters: [String] {
        ["media=\(media)",
         "explicit=\(explicit ? "Yes" : "No")",
         "country=\(country)",
         "limit=\(fetchLimit)",
         "offset=\(fetchOffset)",
         "term=\(searchTermsString)"]
    }
    
    public var url: URL? {
        get throws {
            guard !searchTerms.isEmpty, let query = queryString else {
                throw APIError.empty
            }
            return URL(string: "\(Self.searchUrlString)?\(query)")
        }
    }
    
    public init(searchTerms: [String], offset: Int = 0) {
        self.searchTerms = searchTerms
        self.fetchOffset = offset
    }
}
