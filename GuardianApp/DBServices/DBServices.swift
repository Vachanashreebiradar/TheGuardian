//
//  DBServices.swift
//  GuardianApp
//
//  Created by Biradar, Vachanashree (623-Extern) on 06/12/21.
//

import Foundation
import UIKit
import CoreData


class DBServicesManager {
    
    init() {
       
    }
    func saveData(articles: [Article], context: NSManagedObjectContext) {
       
        articles.forEach { article in
            let dbarticle = NewsArticle(context: context)
            
            dbarticle.webTitle = article.webTitle
            dbarticle.webUrl = article.webUrl
            dbarticle.webPublicationDate = article.webPublicationDate
            dbarticle.fields?.body = article.fields.body
            dbarticle.fields?.thumbnail = article.fields.thumbnail
            
            let fields = NewsArticleFields(context: context)
            fields.body = article.fields.body
            fields.thumbnail = article.fields.thumbnail
            
            dbarticle.fields = fields
        }
        
        do {
            try context.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func loadDBData(context: NSManagedObjectContext) -> [NewsArticle] {
        
        let fetchRequest: NSFetchRequest<NewsArticle> = NewsArticle.fetchRequest()

        do {
               // Peform Fetch Request
               let articles = try context.fetch(fetchRequest)
               print(articles)
            return articles
           } catch {
               print("Unable to Fetch Workouts, (\(error))")
           }
        return []
    }
}
