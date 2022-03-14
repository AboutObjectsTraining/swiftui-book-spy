// Copyright (C) 2022 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import XCTest
@testable import BooksAPI

let searchTerms1 = ["Xcode", "Swift"]

class BooksQueryTests: XCTestCase {
    
    func testEmptyQuery() {
        let query = BooksQuery(searchTerms: [])
        print(query)
        XCTAssertThrowsError(try query.url)
    }
    
    func testQueryWithSearchTerms() async throws {
        let query = BooksQuery(searchTerms: searchTerms1)
        let books = try await APIClient.fetchBooks(query: query)
        print(books)
        XCTAssertFalse(books.isEmpty)
    }
}
