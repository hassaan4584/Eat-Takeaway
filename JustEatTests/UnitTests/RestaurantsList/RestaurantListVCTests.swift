//
//  RestaurantListVCTests.swift
//  JustEatTests
//
//  Created by Hassaan Fayyaz Ahmed on 5/29/22.
//

import XCTest
@testable import JustEat

class RestaurantListVCTests: XCTestCase {

    var sut: RestaurantListViewController!
    private let restaurantListVM = RestaurantListViewModel(restaurantNetworkService: RestaurantNetworkSercice(networkManager: MockNetworkManager()))
    private let ec4mRestaurantsFilename: String = "SearchByPostcode-ec4m"
    private let emptySearchResultFilename: String = "EmptyPostcode"
    private let errorSearchResultFilename: String = "SearchResultError"

    override func setUpWithError() throws {

        let restaurantListController = RestaurantListViewController.createViewController(restaurantListVM: restaurantListVM)
        _ = UINavigationController(rootViewController: restaurantListController)
        sut = restaurantListController
        restaurantListController.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func getRestaurantData(from fileName: String) -> Data? {
        let bundle = Bundle(for: type(of: self))
        guard let bundleUrl = bundle.url(forResource: fileName, withExtension: "json"), let jsonData = try? Data(contentsOf: bundleUrl) else {
            return nil
        }
        return jsonData
    }

    func testRestaurantListScreenInitialState() throws {
        XCTAssertEqual(sut.title, restaurantListVM.screenTitle)
        XCTAssertEqual(sut.emptyRestultsTitleLabel.text, restaurantListVM.emptyDataTitle)
        XCTAssertEqual(sut.searchController.searchBar.placeholder, restaurantListVM.searchBarPlaceholderText)
    }

    func testEmptyResult_whenSearchReturnsEmptyResults_errorIsDisplayedCorrectly() throws {
        // Arrange
        let expectation = expectation(description: "Restaurants Expectation")
        MockURLProtocol.stubResponseData = self.getRestaurantData(from: emptySearchResultFilename)
        let queryStr = "ab12"
        // Act
        sut.searchController.searchBar.searchTextField.text = queryStr
        sut.searchBarSearchButtonClicked(sut.searchController.searchBar)
        restaurantListVM.error.observe(on: self) { _ in
            // Assert
            XCTAssertTrue(self.sut.restaurantListTableview.isHidden)
            XCTAssertFalse(self.sut.emptyRestultsTitleLabel.isHidden)
            XCTAssertEqual(self.sut.emptyRestultsTitleLabel.text, "No Results Found for \(queryStr).\nTry different Code")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testValidResults_whenSearchReturnsValidResults_restaurantTableviewShouldShow() throws {
        // Arrange
        let expectation = expectation(description: "Restaurants Expectation")
        MockURLProtocol.stubResponseData = self.getRestaurantData(from: ec4mRestaurantsFilename)
        let queryStr = "ab12"
        // Act
        sut.searchController.searchBar.searchTextField.text = queryStr
        sut.searchBarSearchButtonClicked(sut.searchController.searchBar)
        sut.restaurantListViewModel.items.observe(on: sut) { _ in
            // Assert
            XCTAssertTrue(self.sut.emptyRestultsTitleLabel.isHidden)
            XCTAssertFalse(self.sut.restaurantListTableview.isHidden)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testCancelledSearch_whenActiveSearchIsCancelled_CancelledErrorIsShown() throws {
        // Arrange
        let expectation = expectation(description: "Restaurants Expectation")
        MockURLProtocol.stubResponseData = self.getRestaurantData(from: ec4mRestaurantsFilename)
        let queryStr = "ab12"
        // Act
        sut.searchController.searchBar.searchTextField.text = queryStr
        sut.searchBarSearchButtonClicked(sut.searchController.searchBar)
        sut.searchBarCancelButtonClicked(sut.searchController.searchBar)
        restaurantListVM.error.observe(on: self) { _ in
            // Assert
            XCTAssertTrue(self.sut.restaurantListTableview.isHidden)
            XCTAssertFalse(self.sut.emptyRestultsTitleLabel.isHidden)
            XCTAssertEqual(self.sut.emptyRestultsTitleLabel.text, "cancelled")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

}
