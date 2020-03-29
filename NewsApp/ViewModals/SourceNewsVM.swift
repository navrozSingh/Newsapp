//
//  SourceNewsVM.swift
//  NewsApp
//
//  Created by Navroz on 29/03/20.
//  Copyright © 2020 Navroz. All rights reserved.
//

import SwiftUI
class SourceNewsVM : ObservableObject {
    let source: Sources
    private var sourcesNewsModal: TopHeadlinesModal?
    @Published var articles = [Articles]()
    @Published var loading = true
    @Published var NoMoreRecords = false

    init(forSource: Sources) {
        self.source = forSource
        //fetchNewsForSource()
    }
    func fetchNewsForSource(page:Int = 1) {
        guard let url = URL(string: Endpoints.SourcesNew.rawValue + source.stringID + "&page=\(page)") else {
            fatalError("Error in source URL")
        }
        loading = true
        URlSession.handler.request(url: url) { [weak self](data, error) in
            guard let self = self else {fatalError("Error in TopHeadlinesVM")}
            do {
                self.sourcesNewsModal = try Helper.dataToCodable(data)
                if let articles = self.sourcesNewsModal?.articles {
                    if self.articles.count > 0, page != 1 {
                        print("previous count \(self.articles.count)")
                        self.articles += articles
                        print("previous count \(self.articles.count)")
                    } else {
                        self.articles = articles
                    }
                }
            } catch {
                print(error)
            }
            self.loading = false
        }
    }
    func fetchMoreNewsForSource() {
        NoMoreRecords = false
        guard let totalRecord = sourcesNewsModal?.totalResults, totalRecord > self.articles.count  else {
            NoMoreRecords = true
            return
        }
        let currentPage = self.articles.count/pageSize
        fetchNewsForSource(page: currentPage+1)
    }
}

