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
  //          NavigationView() {
                TopHeadlines()
//            }.padding(.top, -100)
//                .navigationBarHidden(true)

            .tabItem {
                    Image(systemName: "pencil.and.outline")
                    Text("Headlines")
                }
//            NavigationView() {
                SourcesView()
//            }
//            .padding(.top, -100)
//                .navigationBarTitle("s ", displayMode: .inline)


                .tabItem {
                    Image(systemName: "antenna.radiowaves.left.and.right")
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
