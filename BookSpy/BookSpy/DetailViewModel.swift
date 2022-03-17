// Copyright (C) 2022 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import BooksAPI
import UIKit

extension DetailView {
    
    final class ViewModel: ObservableObject {
        let book: Book
//        @Published var isShowingAlert = false
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
