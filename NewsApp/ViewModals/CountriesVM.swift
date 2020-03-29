//
//  CountriesVM.swift
//  NewsApp
//
//  Created by Navroz on 26/03/20.
//  Copyright © 2020 Navroz. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
class CountriesVM : ObservableObject {
    @Published var countries = [CountryModal]()
    init() {
        guard let file = Bundle.main.url(forResource: "Countries.json", withExtension: nil) else {fatalError("Couldn't find Countries.json in main bundle.")}
        do {
            let jsonData = try Data(contentsOf: file)
            guard let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: String]] else {fatalError("Country json issue")}
            for dict in json {
                let modal = CountryModal(dictionary: dict)
                countries.append(modal)
            }

        } catch {
            fatalError("Couldn't find Countries.json in main bundle.")
        }
    }
}
