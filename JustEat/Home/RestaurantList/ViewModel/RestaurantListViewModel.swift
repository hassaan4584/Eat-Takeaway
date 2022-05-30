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
        self.openRestaurants = Observable([])
        self.allRestaurants = []
    }

    /// Network service resposible for fetching restaurants from server
    private let restaurantsNetworkService: RestaurantNetworkSercice

    /// instance for the most recent network request\
    private var restaurantsDataTask: URLSessionDataTask?

    // MARK: Private functions

    /// Fetches list of restaurants from server and updates observers
    /// - Parameter queryString: The search query used as postcode
    private func fetchRestaurantList(queryString: String) {
        query.value = queryString
        self.loading.value = true
        self.restaurantsDataTask = self.restaurantsNetworkService.searchRestaurantByPostcode(postcode: queryString) { [weak self] restaurantList in
            guard let self = self else { return }
            self.allRestaurants = restaurantList
            self.openRestaurants.value = restaurantList.filter { $0.isOpenNow == true}
            self.loading.value = false
        } onFailure: { [weak self] errStr in
            self?.loading.value = false
            self?.error.value = errStr
        }
    }

    /// Takes action to perform new search
    /// - Parameter searchQuery: postcode on which search is to be triggered
    private func update(searchQuery: String) {
        self.cancelOngoingRequests()
        self.fetchRestaurantList(queryString: searchQuery)
    }

    /// Takes action to cancel any ongoing search.
    private func cancelOngoingRequests() {
        self.restaurantsDataTask?.cancel()
        self.restaurantsDataTask = nil
    }

    // MARK: RestaurantListViewModelInput
    /// Receives message from Controller that search is done
    func didSearch(query: String) {
        self.update(searchQuery: query)
    }

    /// Receives message from Controller that search is cancelled
    func didCancelSearch() {
        self.cancelOngoingRequests()
    }

// MARK: RestaurantListViewModelOutput
    /// All restaurants returned against postcode
    var allRestaurants: [Restaurant]
    /// Currently open, observable list of restaurants returned against postcode
    let openRestaurants: Observable<[Restaurant]>
    /// Postcode that is used as search query
    let query: Observable<String> = Observable("")
    /// Handles the loading indicator based on its state
    let loading: Observable<Bool> = Observable(false)
    /// Observable error message that is to be shown to user
    let error: Observable<String> = Observable("")
    /// Placeholder text in the SearchBar
    var searchBarPlaceholderText: String { "Search on Outcode" }
    /// Returns if there are any open restaurants at the moment
    var isEmpty: Bool { return openRestaurants.value.isEmpty }
    /// Title of the Restaurants List Screen
    var screenTitle: String { "Restaurants" }
    /// Message to be shown to user regarding current search status
    var emptyDataTitle: String { "Search By Postcode"}
}
