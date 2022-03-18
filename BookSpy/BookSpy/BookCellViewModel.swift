// Copyright (C) 2022 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import Foundation
import BooksAPI

// MARK: - BookCell ViewModel
extension BookCell {
    
    final class ViewModel: ObservableObject {
        let book: Book
        
        var detailViewModel: DetailView.ViewModel {
            return DetailView.ViewModel(book: book)
        }

        init(book: Book) {
            self.book = book
        }
    }
}

