// Copyright (C) 2022 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import SwiftUI

struct BookCell: View {
    let viewModel: ViewModel
    
    var body: some View {
        HStack {
            Text(Image(systemName: "book"))
                .imageScale(.large)
            summary
            NavigationLink("") {
                DetailView(viewModel: viewModel.detailViewModel)
            }
        }
        .font(.subheadline)
        .padding(.vertical, 8)
        .listRowBackground(Color.gray.opacity(0.1))
    }
    
    var summary: some View {
        VStack(alignment: .leading) {
            Text(viewModel.book.title)
                .font(.headline)
                .lineLimit(2)
            Spacer()
            Text(viewModel.book.authorName)
        }
        .layoutPriority(1)
    }
}

