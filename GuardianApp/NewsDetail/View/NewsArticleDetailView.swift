//
//  NewsArticleDetailView.swift
//  GuardianApp
//
//  Created by Biradar, Vachanashree (623-Extern) on 05/12/21.
//

import SwiftUI

struct NewsArticleDetailView: View {
    let article: Article
     
    @State var showOnWeb: Bool = false
    var body: some View {
     
            VStack {
                Text("News Article Details")
                    .font(.headline)
                    .foregroundColor(.white)
                VStack(alignment: .leading, spacing: 10.0) {
                    ImageView(imageURL: article.fields.imageURL!)
                        .frame(minHeight: 300)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    Text(article.webTitle)
                        .font(.headline)
                        .lineLimit(3)
                    Text(article.fields.descriptionText)
                        .font(.caption)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                    Text(article.captionText)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("Read on website")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                        .onTapGesture {
                            showOnWeb = true
                        }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue.opacity(0.2)))
            }
            .padding()
          .sheet(isPresented: $showOnWeb) {
            SafariView(url: URL(string: article.webUrl)!)
                .edgesIgnoringSafeArea(.bottom)
        }
          .navigationBarTitleDisplayMode(.inline)
    }
}

struct NewsArticleDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NewsArticleDetailView(article: Article.previewData[0])
    }
}
