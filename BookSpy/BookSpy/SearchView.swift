// Copyright (C) 2022 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import SwiftUI
import BooksAPI

struct SearchView: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        NavigationView {
            listOfBooks
        }
        .searchable(text: $viewModel.inputText)
        // Note: avoids a potential freeze when user taps Cancel button
        .navigationViewStyle(.automatic)
    }
    
    var listOfBooks: some View {
        List {
            ForEach(viewModel.books) { book in
                BookCell(viewModel: viewModel.cellViewModel(for: book))
            }
        }
        .navigationTitle("Book Search")
    }
}

// MARK: - Actions
extension SearchView {
    
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(viewModel: TestData.searchViewVM)
    }
}

