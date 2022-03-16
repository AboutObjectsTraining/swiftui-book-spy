// Copyright (C) 2022 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import BooksAPI
import UIKit

extension DetailView {
    final class ViewModel: ObservableObject {
        let book: Book
        @Published var isShowingAlert = false
        
        var alertTitle: String {
            "Added '\(book.title)' to Library"
        }
        
        init(book: Book) { self.book = book }
    }
}
