//
//  OrderBy.swift
//  GuardianApp
//
//  Created by Biradar, Vachanashree (623-Extern) on 05/12/21.
//

import Foundation

enum OrderBy: String, CaseIterable {
    case `none`
    case newest
    case oldest
    case relevance
}

extension OrderBy: Identifiable {
    var id: Self { self }
}
