//
//  BusinessDetail.swift
//  BusinessReviewProject
//
//  Created by Go Christian Goszal on 28/04/23.
//

import Foundation

struct GetBusinessDetail: Codable {
    let id: String?
    let name: String?
    let image_url: String?
    let rating: Float
    let review_count: Int
    let location: BusinessLocation
    let coordinates: BusinessCoordinates
}

struct BusinessLocation: Codable {
    let display_address: [String]?
}

struct BusinessCoordinates: Codable {
    let latitude: Double
    let longitude: Double
}
