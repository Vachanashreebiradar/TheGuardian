//
//  NewsArticleListView.swift
//  GuardianApp
//
//  Created by Biradar, Vachanashree (623-Extern) on 05/12/21.
//

import SwiftUI
import CoreData


struct NewsArticleListView: View {
    @StateObject var articleNewsVM = NewsArticleViewModel(networkManager: NetworkManager.shared)
   
    @FetchRequest(entity: NewsArticle.entity(), sortDescriptors: [NSSortDescriptor(key: "webPublicationDate", ascending: false)], animation: .default) var results: FetchedResults<NewsArticle>
    @Environment(\.managedObjectContext) var context
    var body: some View {
      
            ZStack {
                if results.isEmpty {
                    List {
                        ForEach(articleNewsVM.articles) { article in
                            ZStack {
                                NewsArticleRowView(article: article)
                                withAnimation {
                                    NavigationLink(destination: NewsArticleDetailView(article: article)) {
                                                  EmptyView()
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                        .frame(width: 0)
                                        .opacity(0)
                                }
                               
                            }
                           
                        }
                        .listRowInsets(.init(top: 10, leading: 10, bottom: 10, trailing: 10))
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                } else {
                    
                    List {
                        ForEach(results) { article in
                            ZStack {
                                NewsArticleDBRow(dbArticle: article)
                                withAnimation {
                                    NavigationLink(destination: NewsArticleDBDetailView(dbArticle: article)) {
                                                  EmptyView()
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                        .frame(width: 0)
                                        .opacity(0)
                                }
                               
                            }
                           
                        }
                        .listRowInsets(.init(top: 10, leading: 10, bottom: 10, trailing: 10))
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                }
           
            }
            .if(results.count == 0, transform: { view in
                view.overlay(overlayView)
            })
            .refreshable {
                    articleNewsVM.fetchNewsAPI(context: context)
            }
            
    }
    @ViewBuilder
    private var overlayView: some View {
        
        switch articleNewsVM.phase {
        case .empty:
            ProgressView()
                .onAppear {
                    articleNewsVM.fetchNewsAPI(context: context)
                }
        case .success(let articles) where articles.isEmpty:
            EmptyPlaceholderView(text: "No Articles", image: nil)
        case .failure(let error):
            RetryView(text: error.localizedDescription, retryAction: {
                articleNewsVM.fetchNewsAPI(context: context)
            })
        default: EmptyView()
        }
    }
    
    
}

struct NewsArticleListView_Previews: PreviewProvider {
    static var previews: some View {
        NewsArticleListView()
    }
}
