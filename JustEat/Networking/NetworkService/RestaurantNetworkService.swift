//
//  RestaurantNetworkService.swift
//  JustEat
//
//  Created by Hassaan Fayyaz Ahmed on 5/22/22.
//

import Foundation

class RestaurantNetworkSercice {
    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }

    /// Network request to fetch restaurants based on postcode
    /// - Parameters:
    ///   - postcode: The outcode/postcode string  based on which the search is to be done
    ///   - onSuccess: Success callback is sent when there are some matching restaurants found
    ///   - onFailure: Error callback sent when no restaurant found or some api error occurs
    /// - Returns: The network request of `URLSessionDataTask`
    func searchRestaurantByPostcode(postcode: String,
                             onSuccess: @escaping (([Restaurant]) -> Void),
                             onFailure: @escaping ((String) -> Void) ) -> URLSessionDataTask {
        let listRestaurantsEndpoint = JustEatEndpoint.searchByPostcode(postcode: postcode)

        return self.networkManager.makeCall(withEndPoint: listRestaurantsEndpoint) { (result: Result<RestaurantList, NetworkError>) in
            switch result {
            case .success(let restaurantList):
                guard let restaurants = restaurantList.restaurants, restaurants.count > 0 else {
                    let errorMessage = "No Results Found for \(postcode).\nTry different Code"
                    onFailure(restaurantList.errorMessage ?? errorMessage)
                    return
                }
                onSuccess(restaurants)
            case .failure(let err):
                onFailure(err.errorMessageStr)
            }
        }
    }
}
