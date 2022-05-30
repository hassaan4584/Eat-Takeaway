//
//  RestaurantListViewModelProtocol.swift
//  JustEat
//
//  Created by Hassaan Fayyaz Ahmed on 5/29/22.
//

import Foundation

protocol RestaurantListViewModelInput {
    /// When the user searches for a postcode
    func didSearch(query: String)
    /// When the current search is cancelled
    func didCancelSearch()
}

protocol RestaurantListViewModelOutput {
    /// List of all Restaurant Items
    var allRestaurants: [Restaurant] { get }
    /// Observable List of Restaurant Items that are currently open
    var openRestaurants: Observable<[Restaurant]> { get }
    /// Observable state indicates if loading is in progress
    var loading: Observable<Bool> { get }
    var query: Observable<String> { get }
    /// Observable Error Message
    var error: Observable<String> { get }
    var isEmpty: Bool { get }
    /// Title of the current Screen
    var screenTitle: String { get }
    /// Message to be displayed when restaurant list is empty
    var emptyDataTitle: String { get }
    /// Text to be displayed on Search Bar
    var searchBarPlaceholderText: String { get }
}

protocol RestaurantListViewModelProtocol: RestaurantListViewModelInput, RestaurantListViewModelOutput {}
