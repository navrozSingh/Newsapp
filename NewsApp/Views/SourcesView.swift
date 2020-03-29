//
//  Sources.swift
//  NewsApp
//
//  Created by Navroz on 28/03/20.
//  Copyright © 2020 Navroz. All rights reserved.
//

import Foundation
import SwiftUI

struct SourcesView: View {
    @ObservedObject var sourcesVM = SourcesVM()
    @State private var selectedSources: Sources?
    @State private var showNewsForSource = false
    var body : some View {
        NavigationView() {
            LoadingView(isShowing: self.$sourcesVM.loading) {
                List(self.sourcesVM.sources){ source in
                    NavigationLink(destination: SourceNews(forSource: source)) {
                        SourcesViewCell(source: source)
                    }
                }
                .navigationBarTitle("All Sources",displayMode: .inline)
            }.onAppear {
                self.sourcesVM.fetchSources()
            }
            .buttonStyle(BorderlessButtonStyle())
        }
    }
}
struct SourcesViewCell: View {
    let source: Sources
    var body : some View {
        VStack {
            HStack {
                Text(source.name ?? "NA")
                    .font(.headline).bold()
                Spacer()
                Text((source.category ?? "NA").uppercased())
                    .font(.caption).bold()
            }
            Spacer()
                Text(source.description ?? "NA")
                    .font(.body).italic()
            Spacer()
            Button(action: {
                if let url = URL(string: self.source.url ?? "") {
                    UIApplication.shared.open(url)
                }
            }) {Text("Visit site").font(.caption).bold()}
            Spacer()
        }
    }
}

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

class SourceNewsVM : ObservableObject {
    let source: Sources
    private var sourcesNewsModal: TopHeadlinesModal?
    @Published var articles = [Articles]()
    @Published var loading = true

    
    init(forSource: Sources) {
        self.source = forSource
        //fetchNewsForSource()
    }
    func fetchNewsForSource() {
        guard let url = URL(string: Endpoints.SourcesNew.rawValue + source.stringID) else {
            fatalError("Error in source URL")
        }
        loading = true
        URlSession.handler.request(url: url) { [weak self](data, error) in
            guard let self = self else {fatalError("Error in TopHeadlinesVM")}
            do {
                self.sourcesNewsModal = try Helper.dataToCodable(data)
                if let articles = self.sourcesNewsModal?.articles {
                    self.articles = articles
                }
            } catch {
                print(error)
            }
            self.loading = false
        }
    }

}
