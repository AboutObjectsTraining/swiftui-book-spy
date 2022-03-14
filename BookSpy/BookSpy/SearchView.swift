// Copyright (C) 2022 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import SwiftUI

struct SearchView: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.books) { book in
                    Text(book.title)
                }
            }
            .navigationTitle("Books")
        }
        .searchable(text: $viewModel.queryText)
        .onSubmit(of: .search) { search() }
    }
    
    private func search() {
        Task {
            await viewModel.performSearch()
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static let viewModel = SearchView.ViewModel()
    static var previews: some View {
        SearchView(viewModel: viewModel)
    }
}

