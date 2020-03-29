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
                        TopHeadlinesCell(article: article, selectedArticle: self.$selectedArticle)
                    }
                    .onTapGesture {
                        self.presentArticle.toggle()
                    }
                }
            }.onAppear {
                self.sourceNewsVM.fetchNewsForSource()
            }
            .navigationBarTitle("News from \(self.source.name ?? "NA")", displayMode: .inline)
            .sheet(isPresented: self.$presentArticle) {
                NewsDetails(article: self.selectedArticle!,showSheetView: self.$presentArticle)
            }
    }
}
