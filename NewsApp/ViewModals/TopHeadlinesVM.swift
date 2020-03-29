//
//  TopHeadlinesVM.swift
//  NewsApp
//
//  Created by Navroz on 26/03/20.
//  Copyright © 2020 Navroz. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
class TopHeadlinesVM : ObservableObject {
    private var topHeadlinesModal: TopHeadlinesModal?
    @Published var articles = [Articles]()
    @Published var loading = true
    @Published var NoMoreRecords = false
    @Published var selectedCountry = CountryModal(dictionary: ["longName": "United States", "shortName": "us"]) {
        didSet{
            fetchHeadlines()
        }
    }
    @Published var openMenu = false
    func fetchHeadlines(page:Int = 1) {
        guard let url = URL(string: Endpoints.TopHeadings.rawValue + selectedCountry.shortName + "&page=\(page)") else {
            fatalError("Error in TopHeadings URL")
        }
        loading = true
        URlSession.handler.request(url: url) { [weak self](data, error) in
            guard let self = self else {fatalError("Error in TopHeadlinesVM")}
            do {
                self.topHeadlinesModal = try Helper.dataToCodable(data)
                if let articles = self.topHeadlinesModal?.articles {
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
    func fetchMoreHeadlines() {
        NoMoreRecords = false
        guard let totalRecord = topHeadlinesModal?.totalResults, totalRecord > self.articles.count  else {
            NoMoreRecords = true
            return
        }
        let currentPage = self.articles.count/pageSize
        fetchHeadlines(page: currentPage+1)
    }
}
