// Copyright (C) 2022 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import SwiftUI
import BooksAPI

struct DetailView: View {
    @ObservedObject var viewModel: ViewModel
    
    var heading: some View {
        VStack {
            LibraryIcon(isInLibrary: viewModel.isInLibrary)
            title
            HStack(alignment: .top) {
                image
                VStack(alignment: .leading) {
                    Text(viewModel.book.authorName)
                        .font(.title3)
                    Text("Price: \(viewModel.book.formattedPrice ?? "--")")
                        .padding(.top, -10)
                        .font(.subheadline)
                    RatingView(viewModel: viewModel)
                }
                .padding(.leading, 12)
            }
            .padding(.vertical, 5)
        }
    }
    
    var title: some View {
        Text(viewModel.book.title)
            .font(.title)
            .multilineTextAlignment(.center)
            .lineSpacing(-1)
            .padding(.vertical, 1)
    }
    
    var image: some View {
        AsyncImage(url: viewModel.book.artworkUrl) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 90)
        } placeholder: {
            ProgressView()
        }
        .border(.green)

    }
        
    var synopsis: some View {
        ScrollView {
            Text(viewModel.book.synopsis ?? "")
                .lineLimit(.max)
                .lineSpacing(7)
                .padding()
        }
    }
    
    var addButton: some View {
        Button(
            action: { addToLibrary() },
            label: {
                Image(systemName: "plus.circle.fill")
                    .symbolRenderingMode(.multicolor)
                    .font(.system(size: 24))
            })
        .disabled(viewModel.isInLibrary)
        .opacity(viewModel.isInLibrary ? 0.4 : 1.0)
    }
    
    var removeButton: some View {
        Button(
            action: { removeFromLibrary() },
            label: {
                Image(systemName: "minus.circle.fill")
                    .symbolRenderingMode(.multicolor)
                    .font(.system(size: 24))
            })
        .disabled(!viewModel.isInLibrary)
        .opacity(viewModel.isInLibrary ? 1.0 : 0.4)
    }
    
    var body: some View {
        VStack {
            Spacer()
            heading
            synopsis
            Spacer()
        }
        .background(Color.gray.opacity(0.2))
        .cornerRadius(20)
        .padding()
        .background(Color.gray.opacity(0.1))
        .navigationBarTitleDisplayMode(.inline)
        .navigationViewStyle(.stack)
        .navigationTitle("Book Details")
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Spacer()
                removeButton
                Spacer()
                addButton
                Spacer()
            }
        }
    }
}

extension DetailView {
    
    private func addToLibrary() {
        Task {
            try await viewModel.addBookToLibrary()
        }
    }
    
    private func removeFromLibrary() {
        Task {
            try await viewModel.removeBookFromLibrary()
        }
    }
}

struct RatingView: View {
    @ObservedObject var viewModel: DetailView.ViewModel
    let maxRating = 5
    var rating: CGFloat { CGFloat(viewModel.rating) }
    
    var body: some View {
        HStack {
            HStack(spacing: 0) {
                ForEach(0..<5) { count in
                    Image(systemName: Int(rating + 0.1) <= count ? "star" : "star.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.primary)
                }
            }
            .frame(height: 12)
        }
        
        Text("\(viewModel.ratingText)")
            .font(.caption)
    }
}

struct LibraryIcon: View {
    let isInLibrary: Bool
    
    var body: some View {
        Image(systemName: "building.columns" + (isInLibrary ? ".fill" : ""))
            .imageScale(.large)
            .font(.system(size: 18))
            .opacity(isInLibrary ? 1.0 : 0.3)
            .padding(.top, 3)
    }
}
struct DetailView_Previews: PreviewProvider {
    static let viewModel = DetailView.ViewModel(book: TestData.book)
    
    static var previews: some View {
        NavigationView {
            DetailView(viewModel: viewModel)
        }
        NavigationView {
            DetailView(viewModel: viewModel)
        }
        .preferredColorScheme(.dark)
    }
}
