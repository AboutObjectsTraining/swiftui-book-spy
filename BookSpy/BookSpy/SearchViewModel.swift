// Copyright (C) 2022 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import BooksAPI

// MARK: - SearchView view model
extension SearchView {
//    @MainActor
    final class ViewModel: ObservableObject {
        @Published var books: [Book] = []
        @Published var queryText: String = ""
        
        var cellViewModels: [BookCell.ViewModel] = []
    }
}

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

// MARK: - BookCell view model
extension BookCell {
    final class ViewModel: ObservableObject {
        let book: Book
        
        init(book: Book) {
            self.book = book
        }
        
        func detailViewModel() -> DetailView.ViewModel {
            return DetailView.ViewModel(book: book)
        }
    }
}

// MARK: - Searching
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
