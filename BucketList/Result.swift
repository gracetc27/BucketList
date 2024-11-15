//
//  Result.swift
//  BucketList
//
//  Created by Grace couch on 13/11/2024.
//

import SwiftUI


struct Result: Codable {
    let query: Query
}

struct Query: Codable {
    let pages: [Int: Page]
}

struct Page: Codable, Comparable {
    let pageid: Int
    let title: String
    let terms: [String: [String]]?

    var description: String {
        terms?["description"]?.first ?? "No further info available"
    }

    static func <(lhs: Page, rhs: Page) -> Bool {
        lhs.title < rhs.title
    }
}
