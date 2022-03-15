// Copyright (C) 2022 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import SwiftUI
import BooksAPI

struct DetailView: View {
    let book: Book
    
    var body: some View {
        VStack {
            Spacer()
            Text(book.title)
                .font(.title)
                .padding()
            Text(book.authorName)
                .font(.title3)
            ScrollView {
                Text(book.synopsis ?? "")
                    .lineLimit(100)
                    .lineSpacing(7)
                    .padding()
            }
            Spacer()
        }
        .padding()
        .background(Color.yellow.opacity(0.1))
    }
}

struct DetailView_Previews: PreviewProvider {
    
    static var previews: some View {
        DetailView(book: TestData.book)
    }
}
