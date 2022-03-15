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
        .searchable(text: $viewModel.queryText)
        .onSubmit(of: .search) { search() }
    }
    
    var listOfBooks: some View {
        List {
            ForEach(viewModel.books) { book in
                BookListCell(book: book)
            }
        }
        .navigationTitle("Books")
    }
}

struct BookListCell: View {
    let book: Book
    
    var body: some View {
        HStack {
            Text(Image(systemName: "book"))
                .imageScale(.large)
            summary
            NavigationLink("") {
                DetailView(book: book)
            }
        }
        .font(.subheadline)
        .padding(.vertical, 8)
    }
    
    var summary: some View {
        VStack(alignment: .leading) {
            Text(book.title)
                .font(.headline)
                .lineLimit(2)
            Spacer()
            Text(book.authorName)
        }
        .layoutPriority(1)
    }
}

// MARK: - Actions
extension SearchView {
    
    private func search() {
        Task {
            await viewModel.performSearch()
        }
    }
}

struct SearchView_Previews: PreviewProvider {
//    static let viewModel: SearchView.ViewModel = {
//        let vm = SearchView.ViewModel()
//        vm.books = TestData.books
//        return vm
//    }()
    static var previews: some View {
        SearchView(viewModel: TestData.searchViewVM)
//            .onAppear {
//                TestData.searchViewVM.books = TestData.searchViewVM.books
//            }
    }
}

