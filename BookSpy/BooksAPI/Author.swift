// Copyright (C) 2022 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import Foundation

public class Author: Identifiable {
    public let id: Int
    public let name: String
    public private(set) var books: [Book] = []
    
    public func add(book: Book) {
        books.append(book)
    }
    
    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

extension Author: Equatable, Hashable {
    public static func == (lhs: Author, rhs: Author) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Author: CustomStringConvertible {
    public var description: String {
        books.reduce("\n\nid: \(id), name: \(name)\n===================\n") { "\($0)\tid: \($1.id), title: \($1.title)\n" }
    }
}
