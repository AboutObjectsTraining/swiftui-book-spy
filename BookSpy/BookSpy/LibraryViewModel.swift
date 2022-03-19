// Copyright (C) 2022 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import BooksAPI

final class LibraryViewModel: ObservableObject {
    @Published var books: [Book] = []

    var cellViewModels: [BookCell.ViewModel] = []

    init() {
        loadBooks()
    }
    

    private func loadBooks() {
        Task {
            if await DataStore.shared.isEmpty {
                await DataStore.shared.loadBooks()
            }
        }
    }
}
