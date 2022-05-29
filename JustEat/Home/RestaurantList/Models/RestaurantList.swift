//
//  RestaurantList.swift
//  JustEat
//
//  Created by Hassaan Fayyaz Ahmed on 5/29/22.
//

import Foundation

struct RestaurantList: Codable {
    /// List of restaurants
    let restaurants: [Restaurant]?
    /// Error Message received from server
    let errorMessage: String?

    enum CodingKeys: String, CodingKey {
        case restaurants = "Restaurants"
        case errorMessage = "message"
    }
}
