//
//  NewsArticleViewModel.swift
//  GuardianApp
//
//  Created by Biradar, Vachanashree (623-Extern) on 05/12/21.
//

import Foundation
import Combine
import CoreData
import SwiftUI

enum DataFetchPhase<T> {
    
    case empty
    case success(T)
    case failure(Error)
}

class NewsArticleViewModel: ObservableObject {
    
    let networkManager: NetworkManager
    let dbServicesManager: DBServicesManager = DBServicesManager()
    
    var disposeBag = Set<AnyCancellable>()
    
    /// The api articles
     var articles: [Article] {
        if case let .success(articles) = phase {
            return articles
        } else {
            return []
        }
    }
    @Published var phase = DataFetchPhase<[Article]>.empty
    
    // MARK: Initialiser
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    
    
    func fetchNewsAPI(context: NSManagedObjectContext) {
        /// Set Empty View first
        self.phase = .empty
        networkManager.getData(from: "Afghanistan", fields: ["body","thumbnail"], orderBy: .newest, responseType: NewsResponse.self)
            .sink { [unowned self] com in
                switch com {
                case .finished:
                    break
                case .failure(let err):
                    phase = .failure(err)
                }
            } receiveValue: { [unowned self] newsResponse in
                phase = .success(newsResponse.response.results ?? [])
                /// load all db articles
                let savedArticles =  dbServicesManager.loadDBData(context: context)
                if savedArticles.count > 0 {
                    var newArticles: [Article] = []
                   _ = articles.map { article in
                        if savedArticles.filter({ dbArticle in
                            dbArticle.webUrl ?? "" == article.webUrl
                        }).count == 0 {
                            newArticles.append(article)
                        }
                    }
                    /// Filter all the new articles which needs to save in the DB
                    if newArticles.count > 0 {
                        dbServicesManager.saveData(articles: newArticles, context: context)
                    }
                } else {
                    /// No previous db data then save all
                    dbServicesManager.saveData(articles: articles, context: context)
                }
               
              
            }.store(in: &disposeBag)

    }
    
}

