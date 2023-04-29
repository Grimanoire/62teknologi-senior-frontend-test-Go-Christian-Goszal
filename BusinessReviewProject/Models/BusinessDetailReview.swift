//
//  BusinessDetailReview.swift
//  BusinessReviewProject
//
//  Created by Go Christian Goszal on 28/04/23.
//

import Foundation

struct GetBusinessDetailReview: Codable {
    let reviews: [BusinessDetailReview]
}

struct BusinessDetailReview: Codable {
    let id: String?
    let text: String?
    let rating: Int
    let user: BusinessUser
}

struct BusinessUser: Codable {
    let name: String?
}
