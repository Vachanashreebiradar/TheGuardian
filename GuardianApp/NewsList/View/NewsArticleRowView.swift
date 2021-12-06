//
//  NewsArticleRowView.swift
//  GuardianApp
//
//  Created by Biradar, Vachanashree (623-Extern) on 05/12/21.
//

import SwiftUI

struct NewsArticleRowView: View {
    let article: Article
    var body: some View {
        VStack(alignment: .leading) {
            ImageView(imageURL: article.fields.imageURL!)
                .frame(minHeight: 300)
                .cornerRadius(10)
                .shadow(radius: 5)
            
            VStack(alignment: .leading, spacing: 10.0) {
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
            }.padding()
           
        }
        .background(RoundedRectangle(cornerRadius: 30).fill(Color.green.opacity(0.2)))
        .shadow(radius: 10)
    }
}

struct NewsArticleRowView_Previews: PreviewProvider {
    static var previews: some View {
        NewsArticleRowView(article: Article.previewData[0])
    }
}
