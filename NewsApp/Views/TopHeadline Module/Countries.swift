//
//  Countries.swift
//  NewsApp
//
//  Created by Navroz on 26/03/20.
//  Copyright © 2020 Navroz. All rights reserved.
//

import SwiftUI

struct Countries: View {
    @ObservedObject var countriesVM = CountriesVM()
    @State var topHeadlines: TopHeadlinesVM
    var body : some View {
        VStack(alignment: .leading) {
           Spacer()
            List(countriesVM.countries ) { country in
                CountryCell(topHeadlines: self.$topHeadlines, country: country)
            }
        }
    .padding()
    .frame(maxWidth: .infinity, alignment: .leading)
    }
}
struct CountryCell: View {
    @Binding var topHeadlines: TopHeadlinesVM
    let country: CountryModal
    @State var selectedCountry: CountryModal?
    var body: some View {
        VStack {
            Spacer()
            if country == self.selectedCountry {
                Text(country.longName)
                    .font(.body).bold()
            } else {
                Text(country.longName)
                    .font(.body)

            }
        }   .onTapGesture {
                self.selectedCountry = self.country
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.topHeadlines.openMenu = false
                self.topHeadlines.selectedCountry = self.country
            }
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        Countries()
//    }
//}

