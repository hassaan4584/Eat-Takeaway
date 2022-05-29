//
//  RestaurantListVCIntegrationTest.swift
//  JustEatTests
//
//  Created by Hassaan Fayyaz Ahmed on 5/30/22.
//

import XCTest
@testable import JustEat

class RestaurantListVCIntegrationTest: XCTestCase {

    var sut: RestaurantListViewController!
    private let restaurantListVM = RestaurantListViewModel(restaurantNetworkService: RestaurantNetworkSercice(networkManager: NetworkManager()))

    override func setUpWithError() throws {

        let restaurantListController = RestaurantListViewController.createViewController(restaurantListVM: restaurantListVM)
        _ = UINavigationController(rootViewController: restaurantListController)
        sut = restaurantListController
        restaurantListController.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testValidResults_whenSearchReturnsValidResults_restaurantTableviewShouldShow() throws {
        // Arrange
        let expectation = expectation(description: "Restaurants Expectation")
        let queryStr = "ec4m"
        // Act
        sut.searchController.searchBar.searchTextField.text = queryStr
        sut.searchBarSearchButtonClicked(sut.searchController.searchBar)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            XCTAssertGreaterThan(self.sut.restaurantListViewModel.items.value.count, 0)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }

}
