//
//  SearchViewVM.swift
//  NewsApp
//
//  Created by Navroz on 29/03/20.
//  Copyright © 2020 Navroz. All rights reserved.
//

import SwiftUI
class SearchViewVM : ObservableObject {
    private var queryNewsModal: TopHeadlinesModal?
    @Published var articles = [Articles]()
    @Published var loading = false
    @Published var showAlert = false
    @Published var showEmptyAlert = false

    func fetchNewsForSource(query: String) {
        guard !query.isEmpty else {
            self.showEmptyAlert = true
            return
        }
        guard let escapedString = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed), let url = URL(string: Endpoints.query.rawValue + escapedString) else {
            self.showAlert = true
            return
        }
        showAlert = false
        loading = true
        URlSession.handler.request(url: url) { [weak self](data, error) in
            guard let self = self else {fatalError("Error in TopHeadlinesVM")}
            do {
                self.queryNewsModal = try Helper.dataToCodable(data)
                if let articles = self.queryNewsModal?.articles {
                    self.articles = articles
                    if self.articles.count == 0 {
                        self.showAlert = true
                    }
                }
            } catch {
                print(error)
            }
            self.loading = false
        }
    }
}
