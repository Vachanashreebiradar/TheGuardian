//
//  NewsResponse.swift
//  GuardianNewsApp
//
//  Created by Biradar, Vachanashree  on 05/12/21.
//

import Foundation


struct NewsResponse: Decodable {
    let response: NewsAPIResponse
}

struct NewsAPIResponse: Decodable {
    
    let status: String
    let message: String?
    let pageSize: Int
    let currentPage: Int
    let pages: Int
    let results: [Article]?
}
