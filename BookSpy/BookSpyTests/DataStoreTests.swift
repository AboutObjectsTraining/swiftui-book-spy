// Copyright (C) 2022 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import XCTest
@testable import BookSpy
@testable import BooksAPI

class DataStoreTests: XCTestCase {
    
    var dataStore: DataStore!
    
    override func setUp() async throws {
        dataStore = DataStore()
        let url = await Bundle(for: type(of: self))
            .url(forResource: dataStore.storeName, withExtension: "json")
        let storeUrl = try await dataStore.storeURL
        print(storeUrl.path)
        if (!FileManager.default.fileExists(atPath: storeUrl.path)) {
            try FileManager.default.copyItem(at: url!, to: storeUrl)
        }
        await dataStore.loadBooks()
    }
    
    override func tearDown() async throws {
        let storeUrl = try await dataStore.storeURL
        try FileManager.default.removeItem(at: storeUrl)
    }

    func testLoadBooks() async throws {
        let count = await dataStore.count
        print(await dataStore.books)
        XCTAssertEqual(count, 3)
    }
    
    func testAddBook() async throws {
        let bookToAdd = try Book.book(for: bookJSONString)
        let originalCount = await dataStore.count
        
        await dataStore.add(book: bookToAdd)
        print(await dataStore.books)
        
        // Persist the store and reload
        try await dataStore.save()
        await dataStore.loadBooks()
        
        let newCount = await dataStore.count
        XCTAssertEqual(newCount, originalCount + 1)
        let books = await dataStore.books
        XCTAssertEqual(books[newCount - 1], bookToAdd)
    }
    
    func testRemoveBook() async throws {
        let originalCount = await dataStore.count
        let books = await dataStore.books
        let bookToRemove = books[0]
        
        await dataStore.remove(book: bookToRemove)
        print(await dataStore.books)
        
        // Persist the store and reload
        try await dataStore.save()
        await dataStore.loadBooks()
        
        let newCount = await dataStore.count
        XCTAssertEqual(newCount, originalCount - 1)
        
        let savedBooks = await dataStore.books
        XCTAssertFalse(savedBooks.contains(bookToRemove))
    }
}


extension Book {
    static func book(for jsonString: String) throws -> Book {
        let data = jsonString.data(using: .utf8)
        return try JSONDecoder().decode(Book.self, from: data!)
    }
}

let bookJSONString = """
{
    "artworkUrl60": "https://is3-ssl.mzstatic.com/image/thumb/Publication/a7/a5/43/mzi.zpoillon.jpg/60x60bb.jpg",
    "artworkUrl100": "https://is3-ssl.mzstatic.com/image/thumb/Publication/a7/a5/43/mzi.zpoillon.jpg/100x100bb.jpg",
    "artistViewUrl": "https://books.apple.com/us/artist/william-shakespeare/2765976?uo=4",
    "trackCensoredName": "Julius Caesar",
    "fileSizeBytes": 901253,
    "formattedPrice": "Free",
    "trackViewUrl": "https://books.apple.com/us/book/julius-caesar/id445888986?uo=4",
    "artistIds": [
        2765976
    ],
    "genreIds": [
        "10036",
        "38",
        "9007",
        "9031",
        "10042",
        "10049"
    ],
    "releaseDate": "2011-06-23T07:00:00Z",
    "trackId": 445888986,
    "trackName": "Julius Caesar",
    "currency": "USD",
    "artistId": 2765976,
    "artistName": "William Shakespeare",
    "genres": [
        "Theater",
        "Books",
        "Arts & Entertainment",
        "Fiction & Literature",
        "Classics",
        "Literary"
    ],
    "price": 0.00,
    "description": "As Julius Caesar ascends to status of dictator-for-life, Marcus Brutus is deeply disturbed. He loves Rome, wants it to succeed and wants it to thrive, but he fears that Caesar's ascent is threatening the democratic principles of the republic. Meanwhile, Cassius, a fellow senator, is quietly building a conspiracy devoted to removing Caesar once and for all. Torn between patriotism, loyalty to his friend, and his conflicted conscience, Brutus reluctantly agrees to join with the assassins, plotting a strike on the Ides of March...",
    "kind": "ebook",
    "averageUserRating": 4.0,
    "userRatingCount": 281
}
"""
