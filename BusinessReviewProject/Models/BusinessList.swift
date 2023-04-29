//
//  BusinessList.swift
//  BusinessReviewProject
//
//  Created by Go Christian Goszal on 27/04/23.
//

import Foundation

struct GetBusinessList: Codable {
    let businesses: [BusinessList]
}

struct BusinessList: Codable {
    let id: String?
    let name: String?
    let image_url: String?
    let rating: Float
    let review_count: Int
}
