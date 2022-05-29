//
//  Restaurant.swift
//  JustEat
//
//  Created by Hassaan Fayyaz Ahmed on 5/22/22.
//

import Foundation
struct Restaurant: Codable, Hashable {

    let id: Int?
    let name: String?
    let logoUrl: String?
    let isOpenNow: Bool?
    let ratingStars: Double?
    let cuisineTypes: [CuisineType]?

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
        case logoUrl = "LogoUrl"
        case isOpenNow = "IsOpenNow"
        case ratingStars = "RatingStars"
        case cuisineTypes = "CuisineTypes"
    }
}
