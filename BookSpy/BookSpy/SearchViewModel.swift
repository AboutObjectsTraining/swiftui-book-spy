// Copyright (C) 2022 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import BooksAPI
import Combine

// MARK: - ViewModel
extension SearchView {
    
    final class ViewModel: ObservableObject {
        @Published var books: [Book] = []
        @Published var inputText = ""
        @Published var queryText = ""
        
        var cellViewModels: [BookCell.ViewModel] = []
        
        private var subscriptions: Set<AnyCancellable> = []
        
        init() {
            loadBooks()
            configurePublishers()
        }
    }
}

// MARK: - Initialization
extension SearchView.ViewModel {
    
    private func configurePublishers() {
        $inputText
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .assign(to: &$queryText)
        
        $queryText
            .sink { _ in
                Task {
                    if !self.queryText.isEmpty {
                        await self.performSearch()
                    }
                }
            }
            .store(in: &subscriptions)
    }
    
    /// Ensure the store is loaded in case the user wants to add or remove a book later.
    private func loadBooks() {
        Task {
            if await DataStore.shared.isEmpty {
                await DataStore.shared.loadBooks()
            }
        }
    }
}

// MARK: - Nested ViewModels
extension SearchView.ViewModel {
    func cellViewModel(for book: Book) -> BookCell.ViewModel {
        if let viewModel = cellViewModels.first(where: { $0.book == book }) {
            return viewModel
        }
        
        let viewModel = BookCell.ViewModel(book: book)
        cellViewModels.append(viewModel)
        return viewModel
    }
}

// MARK: - Effects
extension SearchView.ViewModel {
    
    private var searchTerms: [String] {
        queryText
            .split(separator: " ")
            .map { String($0) }
    }
    
    @MainActor func performSearch() async {
        let query = BooksQuery(searchTerms: searchTerms)
        do {
            books = try await APIClient.fetchBooks(query: query)
        } catch {
            showError(error: error, query: query)
            books = []
        }
    }
    
    func isInLibrary(_ book: Book) async -> Bool {
        return await DataStore.shared.contains(book: book)
    }
    
    func addToLibrary(_ book: Book) {
        Task {
            if await isInLibrary(book) { return }
            await DataStore.shared.add(book: book)
        }
    }
    
    func saveLibrary() {
        Task {
            try await DataStore.shared.save()
        }
    }
}

// MARK: - Logging
private extension SearchView.ViewModel {
    
    func showError(error: Error, query: QueryProtocol) {
        guard let error = error as? APIError else {
            print("error: \(error.localizedDescription)")
            return
        }
        print("No search results;\n\t" +
              "query: \(query)\n\t" +
              "error: \(error.description)\n\t" +
              "url: \(String(describing: try? query.url?.description))")
    }
}
