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
    @Published var selectedCountry = CountryModal(dictionary: ["longName": "United States", "shortName": "us"]) {
        didSet{
            fetchHeadlines()
        }
    }
    @Published var openMenu = false
    init() {
        //fetchHeadlines()
    }
    func fetchHeadlines() {
        guard let url = URL(string: Endpoints.TopHeadings.rawValue + selectedCountry.shortName) else {
            fatalError("Error in TopHeadings URL")
        }
        loading = true
        URlSession.handler.request(url: url) { [weak self](data, error) in
            guard let self = self else {fatalError("Error in TopHeadlinesVM")}
            do {
                self.topHeadlinesModal = try Helper.dataToCodable(data)
                if let articles = self.topHeadlinesModal?.articles {
                    self.articles = articles
                }
            } catch {
                print(error)
            }
            self.loading = false
        }
    }
}
