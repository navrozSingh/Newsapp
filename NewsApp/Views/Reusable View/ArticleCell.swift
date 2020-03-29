//
//  ArticleCell.swift
//  NewsApp
//
//  Created by Navroz on 29/03/20.
//  Copyright © 2020 Navroz. All rights reserved.
//

import SwiftUI
import SDWebImage
import SDWebImageSwiftUI

struct TopHeadlinesCell: View {
    let article: Articles
    @Binding var cellTapped: Bool
    @Binding var selectedArticle: Articles?

    var body: some View {
        VStack(alignment: .center) {
            WebImage(url: URL(string:article.urlToImage ?? ""))
                .resizable()
                .placeholder {
                     Image("Placholder")
                 }
                .indicator(.activity)
                .animation(.easeInOut(duration: 0.5))
                .transition(.fade)
                .aspectRatio(contentMode: .fit)
//                .frame(width: 300, height: 170)
                .clipped()
                .cornerRadius(10)
                .shadow(radius: 5)
                .font(.largeTitle)
            Text(article.title ?? "Title NA")
                .font(.headline).bold().italic()
            Spacer()
        }.onTapGesture {
            self.selectedArticle = self.article
            self.cellTapped.toggle()
        }
    }
}
