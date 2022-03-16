// Copyright (C) 2022 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import Foundation
import BooksAPI

actor DataStore {
    static let shared: DataStore = DataStore()
    
    // TODO: Making books a Set would ensure uniqueness, but
    // making it an array simplifies testing, at least for now.
    private(set) var books: [Book] = []
    private(set) var storeName: String

    init(storeName: String = "Books") {
        self.storeName = storeName
    }
}

// MARK: - File URLs
extension DataStore {
    
    static var documentsDirectoryURL: URL {
        get throws {
            try FileManager.default.url(for: .documentDirectory,
                                        in: .userDomainMask,
                                        appropriateFor: nil, create: false)
        }
    }
    
    var storeURL: URL {
        get throws {
            try Self.documentsDirectoryURL
                .appendingPathComponent(storeName)
                .appendingPathExtension("json")
        }
    }
}

// MARK: - Operations
extension DataStore {
    
    var count: Int {
        get async { books.count }
    }
    
    func loadBooks() async {
        do {
            let data = try Data(contentsOf: storeURL)
            books = try JSONDecoder().decode([Book].self, from: data)
        } catch {
            print("Unable to decode. Make sure values were encoded properly.", error.localizedDescription)
            abort()
        }
    }
    
    func add(book: Book) async {
        books.append(book)
    }
    
    func contains(book: Book) async -> Bool {
        return books.contains(book)
    }
    
    func remove(book: Book) async {
        guard let index = books.firstIndex(of: book) else { return }
        books.remove(at: index)
    }
    
    func save() async throws {
        let data = try JSONEncoder().encode(books)
        try data.write(to: storeURL, options: [.atomic, .noFileProtection])
    }
}
