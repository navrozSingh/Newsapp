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
