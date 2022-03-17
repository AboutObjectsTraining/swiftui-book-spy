// Copyright (C) 2022 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import SwiftUI
import BooksAPI

struct DetailView: View {
    @ObservedObject var viewModel: ViewModel
    
    var title: some View {
        Text(viewModel.book.title)
            .font(.title)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
            .padding(.top, 40)
            .padding(.bottom, 2)
            .overlay(alignment: .top) {
                LibraryIcon(isInLibrary: viewModel.isInLibrary)
            }
    }
    
    var author: some View {
        Text(viewModel.book.authorName)
            .font(.title3)
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
                Image(systemName: "plus.circle")
                    .symbolRenderingMode(.multicolor)
                    .font(.system(size: 24))
            })
        .disabled(viewModel.isInLibrary)
        .opacity(viewModel.isInLibrary ? 0.5 : 1.0)
    }
    
    var removeButton: some View {
        Button(
            action: { removeFromLibrary() },
            label: {
                Image(systemName: "minus.circle")
                    .symbolRenderingMode(.multicolor)
                    .font(.system(size: 24))
            })
        .disabled(!viewModel.isInLibrary)
        .opacity(viewModel.isInLibrary ? 1.0 : 0.4)
    }
    
    var body: some View {
        VStack {
            Spacer()
            title
            author
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

struct LibraryIcon: View {
    let isInLibrary: Bool
    
    var body: some View {
        Image(systemName: "building.columns" + (isInLibrary ? ".fill" : ""))
            .imageScale(.large)
            .font(.system(size: 20))
            .opacity(isInLibrary ? 1.0 : 0.3)
            .padding(.top, 3)
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

struct DetailView_Previews: PreviewProvider {
    static let viewModel = DetailView.ViewModel(book: TestData.book)
    
    static var previews: some View {
        NavigationView {
            DetailView(viewModel: viewModel)
        }
    }
}
