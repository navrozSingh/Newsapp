//
//  Endpoints.swift
//  NewsApp
//
//  Created by Navroz on 28/03/20.
//  Copyright © 2020 Navroz. All rights reserved.
//

import UIKit
let pageSize = 20
enum Endpoints: String {
    case TopHeadings = "http://newsapi.org/v2/top-headlines?country="
    case Sources = "https://newsapi.org/v2/sources"
    case SourcesNew = "http://newsapi.org/v2/top-headlines?sources="
    case query = "https://newsapi.org/v2/everything?q="
}
