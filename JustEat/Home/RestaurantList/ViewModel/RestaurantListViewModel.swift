//
//  RestaurantListViewModel.swift
//  JustEat
//
//  Created by Hassaan Fayyaz Ahmed on 5/22/22.
//

import Foundation

class RestaurantListViewModel: RestaurantListViewModelProtocol {

    init(restaurantNetworkService: RestaurantNetworkSercice) {
        self.restaurantsNetworkService = restaurantNetworkService
        self.items = Observable([])
    }

    private let restaurantsNetworkService: RestaurantNetworkSercice

    /// instance for the most recent network request
    private var restaurantsDataTask: URLSessionDataTask?

    // MARK: Private functions

    private func fetchRestaurantList(queryString: String) {
        query.value = queryString
        self.loading.value = true
        self.restaurantsDataTask = self.restaurantsNetworkService.searchRestaurantByPostcode(postcode: queryString) { [weak self] restaurantList in
            guard let self = self else { return }
            self.items.value = restaurantList.filter { $0.isOpenNow == true}
            self.loading.value = false
        } onFailure: { [weak self] errStr in
            self?.loading.value = false
            self?.error.value = errStr
        }
    }

    private func cancelOngoingRequests() {
        self.restaurantsDataTask?.cancel()
        self.restaurantsDataTask = nil
    }

    private func update(searchQuery: String) {
        self.cancelOngoingRequests()
        self.fetchRestaurantList(queryString: searchQuery)
    }

    // MARK: RestaurantListViewModelInput

    func didSearch(query: String) {
        self.update(searchQuery: query)
    }

    func didCancelSearch() {
        self.cancelOngoingRequests()
    }

// MARK: RestaurantListViewModelOutput
    let items: Observable<[Restaurant]>
    let query: Observable<String> = Observable("")
    let loading: Observable<Bool> = Observable(false)
    let error: Observable<String> = Observable("")
    var searchBarPlaceholderText: String { "Search on Outcode" }
    var isEmpty: Bool { return items.value.isEmpty }
    var screenTitle: String { "Restaurants" }
    var emptyDataTitle: String { "Search By Postcode"}
}
