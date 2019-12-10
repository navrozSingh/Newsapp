//
//  TopHeadlines.swift
//  NewsApp
//
//  Created by Navroz on 28/03/20.
//  Copyright © 2020 Navroz. All rights reserved.
//

import UIKit
import SwiftUI

struct TopHeadlines: View {
    @EnvironmentObject var selectedCountry: CountryModal
    @ObservedObject var topHeadlinesVM = TopHeadlinesVM()
    @State private var selectedArticle: Articles?
    @State private var presentArticle = false
    var body: some View {
        return NavigationView() {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    LoadingView(isShowing: self.$topHeadlinesVM.loading) {
                        List(self.topHeadlinesVM.articles ) { article in
                            TopHeadlinesCell(article: article,cellTapped:self.$presentArticle  ,selectedArticle: self.$selectedArticle)
                                .onAppear {
                                    self.listItemAppears(article)
                                }
                        }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .offset(x: self.topHeadlinesVM.openMenu ? geometry.size.width/2 : 0)
                    .disabled(self.topHeadlinesVM.openMenu ? true : false)
                    if self.topHeadlinesVM.openMenu {
                        Countries(topHeadlines: self.topHeadlinesVM)
                          .frame(width: geometry.size.width/2)
                          .transition(.move(edge: .leading))
                    }
                }.sheet(isPresented: self.$presentArticle) {
                    NewsDetails(article: self.selectedArticle!,showSheetView: self.$presentArticle)
                }
                .alert(isPresented: self.$topHeadlinesVM.NoMoreRecords) {
                    Alert(title: Text("Alert"), message: Text("No more results"), dismissButton: .default(Text("Close")))
                }
            }.onAppear(){
                self.topHeadlinesVM.fetchHeadlines()
            }
            .navigationBarTitle("Top Headlines from \(self.topHeadlinesVM.selectedCountry.longName)", displayMode: .inline)
        
            .navigationBarItems(leading: (
                Button(action: {
                    withAnimation {
                        self.topHeadlinesVM.openMenu.toggle()
                    }
                }) {
                    Image(systemName: "line.horizontal.3")
                        .imageScale(.large)
                }
            ))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
extension TopHeadlines {
    private func listItemAppears<Item: Identifiable>(_ item: Item) {
        if topHeadlinesVM.articles.isLastItem(item) {
            topHeadlinesVM.fetchMoreHeadlines()
        }
    }
}

//TODO: Gester implementation

//        let drag = DragGesture()
//            .onEnded {
//                if $0.translation.width < -100 {
//                    withAnimation {
//                        self.topHeadlinesVM.openMenu = false
//                    }
//                }
//            }
