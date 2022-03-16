// Copyright (C) 2022 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import SwiftUI
import BooksAPI

struct DetailView: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            Spacer()
            Text(viewModel.book.title)
                .font(.title)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .padding(.top, 18)
                .padding(.bottom, 2)
            Text(viewModel.book.authorName)
                .font(.title3)
            ScrollView {
                Text(viewModel.book.synopsis ?? "")
                    .lineLimit(.max)
                    .lineSpacing(7)
                    .padding()
            }
            Spacer()
        }
        .background(Color.gray.opacity(0.2))
        .cornerRadius(20)
        .padding()
        .background(Color.gray.opacity(0.1))
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(viewModel.book.title)
        .toolbar {
            Button("Add to Library") {
                viewModel.isShowingAlert = true
            }
            .alert(viewModel.alertTitle, isPresented: $viewModel.isShowingAlert) {
                Button("Okay", role: .cancel) {
                    addToLibrary()
                }
            }
        }
    }
}

extension DetailView {
    
    private func addToLibrary() {
        // TODO: Implement me
    }
}

struct DetailView_Previews: PreviewProvider {
    static let viewModel = DetailView.ViewModel(book: TestData.book)
    
    static var previews: some View {
        DetailView(viewModel: viewModel)
    }
}
