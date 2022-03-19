// Copyright (C) 2022 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import SwiftUI

struct LibraryView: View {
    @ObservedObject var viewModel: SearchView.ViewModel
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.authors) { author in
                    Section {
                        ForEach(author.books) { book in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(book.title)
                                    .font(.callout)
                                Text("\(book.averageRating ?? 0)" +
                                     " Rating out of \(book.ratingCount ?? 0)" +
                                     " Reviews")
                                    .font(.caption)
                            }
                        }
                    } header: {
                        Text(author.name)
                    }
                }
            }
            .navigationTitle("Library")
        }
        .onAppear() {
            Task {
                await viewModel.updateAuthors()
            }
        }
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView(viewModel: TestData.searchViewVM)
    }
}
