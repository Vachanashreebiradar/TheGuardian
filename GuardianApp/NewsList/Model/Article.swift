//
//  Article.swift
//  GuardianApp
//
//  Created by Biradar, Vachanashree  on 04/12/21.
//

import Foundation

fileprivate let relativeDateFormatter = RelativeDateTimeFormatter()
struct Article {
    let id: String
    let type: String
    let sectionId: String
    let sectionName: String
    let webPublicationDate: String
    let webTitle: String
    let webUrl: String
    let fields: Fields
    
    var articleWebURL: URL {
        return URL(string: webUrl)!
    }
    
    var captionText: String {
        do {
           
            let publishedDate =  try Date(webPublicationDate, strategy: .iso8601)
            return "published ‧ \(relativeDateFormatter.localizedString(for: publishedDate, relativeTo: Date()))"
        } catch {
            return ""
        }
    
    }
}

extension Article: Codable{}
extension Article: Equatable{}
extension Article: Identifiable{}

extension Article {
    static var previewData: [Article] {
        let previewDataURL = Bundle.main.url(forResource: "NewsPreviewData", withExtension: "json")!
        let data = try! Data(contentsOf: previewDataURL)
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        
        let apiResponse = try! jsonDecoder.decode(NewsResponse.self, from: data)
        return apiResponse.response.results ?? []
    }
}


struct Fields {
    let body: String?
    let thumbnail: String?
    
    var descriptionText: String {
        guard let body = body else {
            return ""
        }

       return body.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil) 
    }
    
    var imageURL: URL? {
        guard let thumbnail = thumbnail else {
            return nil
        }
        return URL(string: thumbnail)
    }
}

extension Fields: Codable{}
extension Fields: Equatable{}
