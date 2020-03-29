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
    @State private var showNewsForSource = false
    var body : some View {
        NavigationView() {
            LoadingView(isShowing: self.$sourcesVM.loading) {
                List(self.sourcesVM.sources){ source in
                    NavigationLink(destination: SourceNews(forSource: source)) {
                        SourcesViewCell(source: source)
                    }
                }
                .navigationBarTitle("All Sources",displayMode: .inline)
            }.onAppear {
                self.sourcesVM.fetchSources()
            }
            .buttonStyle(BorderlessButtonStyle())
        }
    }
}
struct SourcesViewCell: View {
    let source: Sources
    var body : some View {
        VStack {
            HStack {
                Text(source.name ?? "NA")
                    .font(.headline).bold()
                Spacer()
                Text((source.category ?? "NA").uppercased())
                    .font(.caption).bold()
            }
            Spacer()
                Text(source.description ?? "NA")
                    .font(.body).italic()
            Spacer()
            Button(action: {
                if let url = URL(string: self.source.url ?? "") {
                    UIApplication.shared.open(url)
                }
            }) {Text("Visit site").font(.caption).bold()}
            Spacer()
        }
    }
}




