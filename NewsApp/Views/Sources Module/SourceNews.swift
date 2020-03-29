//
//  SourceNews.swift
//  NewsApp
//
//  Created by Navroz on 29/03/20.
//  Copyright © 2020 Navroz. All rights reserved.
//
import SwiftUI
struct SourceNews: View {
    let source: Sources
    @ObservedObject var sourceNewsVM:SourceNewsVM
    @State private var selectedArticle: Articles?
    @State private var presentArticle = false

    init(forSource: Sources){
        self.source = forSource
        self.sourceNewsVM = SourceNewsVM(forSource: self.source)
        
    }
    var body : some View {
        return
            ZStack(alignment: .leading) {
                LoadingView(isShowing: self.$sourceNewsVM.loading) {
                    List(self.sourceNewsVM.articles ) { article in
                        TopHeadlinesCell(article: article, cellTapped: self.$presentArticle, selectedArticle: self.$selectedArticle)
                        .onAppear {
                            self.listItemAppears(article)
                        }
                    }
//                    .onTapGesture {
//                        self.presentArticle.toggle()
//                    }
                }
            }.onAppear {
                self.sourceNewsVM.fetchNewsForSource()
            }
            .navigationBarTitle("News from \(self.source.name ?? "NA")", displayMode: .inline)
            .sheet(isPresented: self.$presentArticle) {
                NewsDetails(article: self.selectedArticle!,showSheetView: self.$presentArticle)
            }
        .alert(isPresented: self.$sourceNewsVM.NoMoreRecords) {
            Alert(title: Text("Alert"), message: Text("No more results"), dismissButton: .default(Text("Close")))
        }
    }
}

extension SourceNews {
    private func listItemAppears<Item: Identifiable>(_ item: Item) {
        if sourceNewsVM.articles.isLastItem(item) {
            sourceNewsVM.fetchMoreNewsForSource()
        }
    }
}
