//
//  JustEatEndpoint.swift
//  JustEat
//
//  Created by Hassaan Fayyaz Ahmed on 5/22/22.
//

import Foundation

enum JustEatEndpoint: Endpoint {

    case searchByPostcode(postcode: String)

    var baseURL: URL {
        guard let url = URL(string: "https://uk.api.just-eat.io") else {
            fatalError("Invalid Base URL")
        }
        return url
    }

    var path: String {
        switch self {
        case .searchByPostcode(let postcode):
            return "restaurants/bypostcode/\(postcode)"
        }
    }

    var queryParams: [String: String]? {
        switch self {
        case .searchByPostcode:
            return [:]
        }
    }

    var headers: [String: String]? {
        return nil
    }

    var httpMethod: String {
        switch self {
        case .searchByPostcode:
            return HttpMethod.get.rawValue
        }
    }

}
