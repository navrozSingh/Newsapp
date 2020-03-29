//
//  Sources.swift
//  NewsApp
//
//  Created by Navroz on 28/03/20.
//  Copyright © 2020 Navroz. All rights reserved.
//

import Foundation
import SwiftUI

struct SourcesView: View {
    @ObservedObject var sourcesVM = SourcesVM()
    @State private var selectedSources: Sources?

    var body : some View {
        NavigationView() {
            LoadingView(isShowing: self.$sourcesVM.loading) {
                List(self.sourcesVM.sources){ source in
                    NavigationLink(destination: SourceNews(source: source)) {
                        SourcesViewCell(source: source, selectedSource: self.$selectedSources)
                    }
                }
                .navigationBarTitle("All Sources")
            }.buttonStyle(BorderlessButtonStyle())
        }
    }
}
struct SourcesViewCell: View {
    let source: Sources
    @Binding var selectedSource: Sources?
    var body : some View {
        VStack {
                HStack {
                    if source == self.selectedSource {
                        Text(source.name ?? "NA")
                            .font(.title).bold()
                    } else {
                        Text(source.name ?? "NA")
                            .font(.title)
                    }
                    Spacer()
                    if source == self.selectedSource {
                        Text((source.category ?? "NA").uppercased())
                            .font(.caption).bold()
                    } else {
                        Text((source.category ?? "NA").uppercased())
                            .font(.caption).italic()
                    }
                }
                Spacer()
                if source == self.selectedSource {
                    Text(source.description ?? "NA")
                        .font(.body).bold()
                } else {
                    Text(source.description ?? "NA")
                        .font(.body)
                }
                Spacer()
                Button(action: {
                    if let url = URL(string: self.source.url ?? "") {
                        UIApplication.shared.open(url)
                    }
                }) {Text("Visit site").font(.caption).bold()}
                Spacer()
                }.onTapGesture {self.selectedSource = self.source}
    }
}

struct SourceNews: View {
    let source: Sources
    var body : some View {
        Text(source.name!)
    }
}
/***/
