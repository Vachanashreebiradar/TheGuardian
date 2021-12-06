//
//  NewsArticleDBRow.swift
//  GuardianApp
//
//  Created by Biradar, Vachanashree (623-Extern) on 06/12/21.
//

import SwiftUI
import CoreData

struct NewsArticleDBRow: View {
    let dbArticle: NewsArticle
    var body: some View {
        VStack(alignment: .leading) {
           
            ImageView(imageURL: imageURL!)
                .frame(minHeight: 300)
                .cornerRadius(10)
                .shadow(radius: 5)
            VStack(alignment: .leading, spacing: 10.0) {
                Text(dbArticle.webTitle ?? "")
                    .font(.headline)
                    .lineLimit(3)
                Text(descriptionText)
                    .font(.caption)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                Text(captionText)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }.padding()
           
        }
        .background(RoundedRectangle(cornerRadius: 30).fill(Color.green.opacity(0.2)))
        .shadow(radius: 10)
    }
    
    /// Image Url
    var imageURL: URL? {
        guard let thumbnail = dbArticle.fields?.thumbnail else {
            return nil
        }
        return URL(string: thumbnail)
    }
    
    
    fileprivate let relativeDateFormatter = RelativeDateTimeFormatter()
    
    /// Localised string for the given date
    var captionText: String {
        do {
           
            let publishedDate =  try Date(dbArticle.webPublicationDate ?? "", strategy: .iso8601)
            return "published ‧ \(relativeDateFormatter.localizedString(for: publishedDate, relativeTo: Date()))"
        } catch {
            return ""
        }
    
    }
    
    /// Text without HTML tags
    var descriptionText: String {
        guard let body = dbArticle.fields?.body else {
            return ""
        }

       return body.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }

}

struct NewsArticleDBRow_Previews: PreviewProvider {
    static var previews: some View {
        NewsArticleDBRow(dbArticle: NewsArticle.init())
    }
}
