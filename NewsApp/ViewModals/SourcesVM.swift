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
class SourcesVM : ObservableObject {
    private var sourcesModal: SourcesModal?
    @Published var sources = [Sources]()
    @Published var loading = true
    init() {
        fetchSources()
    }
    func fetchSources() {
        guard let url = URL(string: Endpoints.Sources.rawValue) else {
            fatalError("Error in sources URL")
        }
        loading = true
        URlSession.handler.request(url: url) { [weak self](data, error) in
            guard let self = self else {fatalError("Error in sources")}
            do {
                self.sourcesModal = try Helper.dataToCodable(data)
                if let sources = self.sourcesModal?.sources {
                    self.sources = sources
                }
            } catch {
                print(error)
            }
            self.loading = false
        }
    }
    
}
