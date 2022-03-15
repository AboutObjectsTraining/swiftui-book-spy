// Copyright (C) 2022 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import SwiftUI
import BooksAPI

struct DetailView: View {
    let viewModel: ViewModel
    
    var body: some View {
        VStack {
            Spacer()
            Text(viewModel.book.title)
                .font(.title)
                .padding()
            Text(viewModel.book.authorName)
                .font(.title3)
            ScrollView {
                Text(viewModel.book.synopsis ?? "")
                    .lineLimit(1000)
                    .lineSpacing(7)
                    .padding()
            }
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.1))
    }
}

struct DetailView_Previews: PreviewProvider {
    static let viewModel = DetailView.ViewModel(book: TestData.book)
    
    static var previews: some View {
        DetailView(viewModel: viewModel)
    }
}
