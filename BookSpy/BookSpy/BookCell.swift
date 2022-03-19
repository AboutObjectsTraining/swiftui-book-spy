// Copyright (C) 2022 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import SwiftUI

struct BookCell: View {
    let viewModel: ViewModel
    
    var summary: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(viewModel.book.title)
                .font(.headline)
                .lineLimit(2)
            Text(viewModel.book.authorName)
        }
        .layoutPriority(1)
    }
    
    var image: some View {
        AsyncImage(url: viewModel.book.artworkUrl) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 72)
                    .layoutPriority(1)
            } else if phase.error == nil {
                ProgressView()
            } else {
                Color.red
            }
        }
    }

    var body: some View {
        HStack(spacing: 15) {
            image
            summary
            NavigationLink("") {
                DetailView(viewModel: viewModel.detailViewModel)
            }
        }
        .font(.subheadline)
        .listRowBackground(Color.gray.opacity(0.1))
    }
}

struct BookCell_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(viewModel: TestData.searchViewVM)
    }
}
