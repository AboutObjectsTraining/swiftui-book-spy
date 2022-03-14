// Copyright (C) 2022 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import SwiftUI
import BooksAPI

extension SearchView {
//    @MainActor
    final class ViewModel: ObservableObject {
        @Published var books: [Book] = []
        @Published var queryText: String = ""
        
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
}

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
