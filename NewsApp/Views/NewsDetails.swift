//
//  HeadlineDetails.swift
//  NewsApp
//
//  Created by Navroz on 28/03/20.
//  Copyright © 2020 Navroz. All rights reserved.
//

import UIKit
import SwiftUI
import SDWebImage
import SDWebImageSwiftUI
struct NewsDetails: View {
    let article : Articles
    @Binding var showSheetView: Bool
    var body: some View {
        NavigationView {
           VStack{
               ScrollView() {
               WebImage(url: URL(string:article.urlToImage ?? ""))
                   .resizable()
                   .placeholder {
                        Image("Placholder")
                    }
                   .indicator(.activity)
                   .animation(.easeInOut(duration: 0.5))
                   .transition(.fade)
                   .aspectRatio(contentMode: .fit)
                   .clipped()
                   .font(.headline)
               Spacer()
                  Text(article.title ?? "title - NA")
                    .font(.body).italic()
                   .padding(10)
                Spacer()
                   Text(article.description ?? "Content - NA")
                    .font(.title).bold()
                    .padding(10)
                Spacer()
                Text("Source : \(article.source?.name ?? " - NA")")
                    .font(.caption).bold()
                    .frame(alignment: .leading)
                    .padding(10)
                Button(action: {
                    if let url = URL(string: self.article.url ?? "") {
                        UIApplication.shared.open(url)
                    }
                }) {Text("Visit site").font(.caption).bold()}
                
               }.padding(.bottom,10)
           }.navigationBarTitle(Text("Details"), displayMode: .inline)
                   .navigationBarItems(trailing: Button(action: {
                        self.showSheetView.toggle()
            }) {Text("Done").bold()})
        }
    }
}
