//
//  CountryModal.swift
//  NewsApp
//
//  Created by Navroz on 26/03/20.
//  Copyright © 2020 Navroz. All rights reserved.
//

import Foundation

class CountryModal: ObservableObject, Identifiable, Equatable {
    let shortName: String
    let longName: String
    @Published var isSelected = false
    let id = UUID()
    init(dictionary: [String: String]) {
        shortName = dictionary["shortName",default: ""]
        longName = dictionary["longName",default: ""]
    }
    static func == (rhs: CountryModal ,lhs : CountryModal) -> Bool {
        lhs.shortName == rhs.shortName
    }
}

