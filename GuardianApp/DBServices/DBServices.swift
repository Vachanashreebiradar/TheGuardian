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
    
    // MARK: Initializer
    init() {
       
    }
    
    // MARK: DB Services
    /*
        1. This will take all the api articles response which is of type Article
        2. Then it will iterate through the list
        3. Creates NewsArticle model list
        4. then saves the changes to context
    */
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
    
    /*
        1. This will load all the entries of NewsArticles
        2. It will fetch using the context
    */
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
