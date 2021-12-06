//
//  NewsArticleDBDetailView.swift
//  GuardianApp
//
//  Created by Biradar, Vachanashree (623-Extern) on 06/12/21.
//

import SwiftUI


struct NewsArticleDBDetailView: View {
    let dbArticle: NewsArticle
    @State var showOnWeb: Bool = false
    var body: some View {
        GeometryReader { _ in
            VStack {
                Text("News Article Details")
                    .font(.headline)
                VStack(alignment: .leading, spacing: 10.0) {
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
                    Text("Read on website")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                        .onTapGesture {
                            showOnWeb = true
                        }
                    Spacer()
                }
                .frame(maxHeight: .infinity)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue.opacity(0.2)))
            }
            .navigationBarTitleDisplayMode(.inline)
            .padding()
          .sheet(isPresented: $showOnWeb) {
              if let webUrl = dbArticle.webUrl {
                  SafariView(url: URL(string: webUrl)!)
                      .edgesIgnoringSafeArea(.bottom)
              }
          }
        }
           
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

struct NewsArticleDBDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NewsArticleDBDetailView(dbArticle: NewsArticle.init())
    }
}
