// Copyright (C) 2022 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import BooksAPI
import UIKit

extension DetailView {
    
    final class ViewModel: ObservableObject {
        let book: Book
        @Published var isInLibrary: Bool = false

        var alertTitle: String {
            "Added '\(book.title)' to Library"
        }
        
        init(book: Book) {
            self.book = book
            Task {
                isInLibrary = await DataStore.shared.contains(book: book)
            }
        }
    }
}

// MARK: - Actions
extension DetailView.ViewModel {
    @MainActor func addBookToLibrary() async throws {
        await DataStore.shared.add(book: book)
        try await DataStore.shared.save()
        isInLibrary = true
    }
    
    @MainActor func removeBookFromLibrary() async throws {
        await DataStore.shared.remove(book: book)
        try await DataStore.shared.save()
        isInLibrary = false
    }
}

// MARK: Ratings
extension DetailView.ViewModel {
    private static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 1
        return formatter
    }()
    
    var rating: Double {
        book.averageRating ?? 0
    }
    
    var ratingText: String {
        let ratingText = Self.numberFormatter.string(from: NSNumber(value: rating)) ?? "-.-"
        return "\(ratingText)  \(book.ratingCount ?? 0) Reviews"
    }
    
    func imageName(for index: Int) -> String {
        let intRating = Int(rating + 0.1)
        let remainder = rating - Double(intRating)
        
        return index < intRating ? "star.fill" :
        index == intRating && remainder > 0.4 ? "star.leadinghalf.filled" : "star"
    }
}
