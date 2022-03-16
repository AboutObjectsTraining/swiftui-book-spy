// Copyright (C) 2022 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import Foundation

@available(iOS 10.0, *)
let iso8601DateFormatter = ISO8601DateFormatter()

public struct BooksQueryResult: Codable {
    enum CodingKeys: String, CodingKey {
        case count = "resultCount"
        case books = "results"
    }
    let count: Int
    let books: [Book]
}

public struct Book: Codable, Identifiable {
    public let id: Int
    public let title: String
    public let authorId: Int
    public let authorName: String
    public let synopsis: String?
    public let releaseDate: Date?
    public let formattedPrice: String?
    public let genres: [String]
    public let fileSizeBytes: Int?
    public let averageRating: Double?
    public let ratingCount: Int?
    public let artworkUrl: URL
    public let detailsUrl: URL
    
    private enum CodingKeys: String, CodingKey {
        case id = "trackId"
        case title = "trackCensoredName"
        case authorId = "artistId"
        case authorName = "artistName"
        case synopsis = "description"
        case releaseDate
        case formattedPrice
        case genres
        case fileSizeBytes
        case averageRating = "averageUserRating"
        case ratingCount = "userRatingCount"
        case artworkUrl = "artworkUrl100"
        case detailsUrl = "trackViewUrl"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        authorId = try container.decode(Int.self, forKey: .authorId)
        authorName = try container.decode(String.self, forKey: .authorName)
        synopsis = try container.decodeIfPresent(String.self, forKey: .synopsis)
        let dateString = try container.decode(String.self, forKey: .releaseDate)
        releaseDate = iso8601DateFormatter.date(from: dateString)
        formattedPrice = try container.decodeIfPresent(String.self, forKey: .formattedPrice)
        genres = try container.decode([String].self, forKey: .genres)
        fileSizeBytes = try container.decodeIfPresent(Int.self, forKey: .fileSizeBytes)
        averageRating = try container.decodeIfPresent(Double.self, forKey: .averageRating)
        ratingCount = try container.decodeIfPresent(Int.self, forKey: .ratingCount)
        artworkUrl = try container.decode(URL.self, forKey: .artworkUrl)
        detailsUrl = try container.decode(URL.self, forKey: .detailsUrl)
    }
    
    public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try values.encode(id, forKey: .id)
        try values.encode(title, forKey: .title)
        try values.encode(authorId, forKey: .authorId)
        try values.encode(authorName, forKey: .authorName)
        try values.encode(synopsis, forKey: .synopsis)
        var dateString: String? = nil
        if let releaseDate = releaseDate {
            dateString = iso8601DateFormatter.string(from: releaseDate)
        }
        try values.encode(dateString, forKey: .releaseDate)
        try values.encode(formattedPrice, forKey: .formattedPrice)
        try values.encode(genres, forKey: .genres)
        try values.encode(fileSizeBytes, forKey: .fileSizeBytes)
        try values.encode(averageRating, forKey: .averageRating)
        try values.encode(ratingCount, forKey: .ratingCount)
        try values.encode(artworkUrl, forKey: .artworkUrl)
        try values.encode(detailsUrl, forKey: .detailsUrl)
    }
}

extension Book: Equatable {
    public static func ==(book1: Book, book2: Book) -> Bool {
        return book1.id == book2.id
    }
}

extension Book: CustomStringConvertible {
    public var description: String {
        return """
                {
                    id: \(id)
                    title: \(title)
                    author: \(authorName)
                }
                """
    }
}
