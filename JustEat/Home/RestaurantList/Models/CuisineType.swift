//
//  CuisineType.swift
//  JustEat
//
//  Created by Hassaan Fayyaz Ahmed on 5/29/22.
//

import Foundation

// MARK: - CuisineType
struct CuisineType: Codable, Hashable {
    let id: Int?
    let isTopCuisine: Bool?
    let name: String?
    let seoName: String?

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case isTopCuisine = "IsTopCuisine"
        case name = "Name"
        case seoName = "SeoName"
    }
}
