//
//  ContentView.swift
//  NewsApp
//
//  Created by Navroz on 28/03/20.
//  Copyright © 2020 Navroz. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView(){
            TopHeadlines()
            .tabItem {
                    Image(systemName: "pencil.and.outline")
                    Text("Headlines")
                }
            
                SourcesView()
                .tabItem {
                    Image(systemName: "antenna.radiowaves.left.and.right")
                    Text("Sources")
            }
            
                SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Sources")
            }

        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
