//
//  SearchView.swift
//  NewsApp
//
//  Created by Navroz on 29/03/20.
//  Copyright © 2020 Navroz. All rights reserved.
//

import SwiftUI
struct SearchView: View {
    @State private var selectedArticle: Articles?
    @State private var presentArticle = false
    @ObservedObject var searchViewVM = SearchViewVM()
    @State var textToSearch = ""
    var body : some View {
        return NavigationView() {
//            ScrollView {
                VStack() {
                    HStack {
                        Spacer()
                        TextField(!self.searchViewVM.loading ? "Search": "Searching...", text: self.$textToSearch)
                            .font(.body)
                        .frame(minHeight: 40)
                        Button(action: {
                            self.searchViewVM.fetchNewsForSource(query: self.textToSearch)
//                            self.textToSearch = ""
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }) {Text("Submit").font(.body).bold()}
                        Spacer()
                    }
                    .background(Color.secondary.colorInvert())
                    .foregroundColor(Color.primary)
//                    .cornerRadius(20)
                    .opacity(1)
                    LoadingView(isShowing: self.$searchViewVM.loading) {
                        List(self.searchViewVM.articles ) { article in
                            TopHeadlinesCell(article: article, cellTapped: self.$presentArticle, selectedArticle: self.$selectedArticle)
                            .onAppear {
                                self.listItemAppears(article)
                            }
                        }
                    }
                    .alert(isPresented: self.$searchViewVM.showAlert) {
                        Alert(title: Text("Alert"), message: Text("No results found"), dismissButton: .default(Text("Close")))
                    }
                    .alert(isPresented: self.$searchViewVM.showEmptyAlert) {
                        Alert(title: Text("Alert"), message: Text("Please enter some text!!"), dismissButton: .default(Text("Close")))
                    }
                    .alert(isPresented: self.$searchViewVM.NoMoreRecords) {
                        Alert(title: Text("Alert"), message: Text("No more results"), dismissButton: .default(Text("Close")))
                    }
                }
                .navigationBarTitle(!self.searchViewVM.loading ? "Search": "Searching", displayMode: .inline)
                .sheet(isPresented: self.$presentArticle) {
                    NewsDetails(article: self.selectedArticle!,showSheetView: self.$presentArticle)
                }
            }
//        }
    }
}
extension SearchView {
    private func listItemAppears<Item: Identifiable>(_ item: Item) {
        if searchViewVM.articles.isLastItem(item) {
            searchViewVM.fetchMoreNewsForSource(query:textToSearch)
        }
    }
}
