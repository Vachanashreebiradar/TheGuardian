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
            if let img = imageDownload() {
                img
                    .resizable()
                    .frame(minHeight: 300)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            } else {
                HStack {
                    Spacer()
                    Image(systemName: "photo")
                        .imageScale(.large)
                    Spacer()
                }
                    .frame(minHeight: 300)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .background(Color.gray.opacity(0.4))
            }
              
               
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
    
    private func imageDownload() -> Image? {
        if let image = ImageCache.getImageCache().get(forKey: "\(URL(string: dbArticle.fields?.thumbnail ?? "")!)") {
            return Image(uiImage: image)
        }
        guard let url = URL(string: dbArticle.fields?.thumbnail ?? ""),
        let data = try? Data(contentsOf: url),
              let img = UIImage(data: data) else {
                  return nil
              }
        ImageCache.getImageCache().set(forKey: "\(url)", image: img)
        return Image(uiImage: img)
    }
    fileprivate let relativeDateFormatter = RelativeDateTimeFormatter()
    var captionText: String {
        do {
           
            let publishedDate =  try Date(dbArticle.webPublicationDate ?? "", strategy: .iso8601)
            return "published ‧ \(relativeDateFormatter.localizedString(for: publishedDate, relativeTo: Date()))"
        } catch {
            return ""
        }
    
    }
    
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
