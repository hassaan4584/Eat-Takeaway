//
//  RestaurantListVMTests.swift
//  JustEatTests
//
//  Created by Hassaan Fayyaz Ahmed on 5/29/22.
//

import XCTest
@testable import JustEat

class RestaurantListVMTests: XCTestCase {

    var sut: RestaurantListViewModel!
    private let ec4mRestaurantsFilename: String = "SearchByPostcode-ec4m"
    private let emptySearchResultFilename: String = "EmptyPostcode"
    private let errorSearchResultFilename: String = "SearchResultError"

    override func setUpWithError() throws {
        sut = RestaurantListViewModel(restaurantNetworkService: RestaurantNetworkSercice(networkManager: MockNetworkManager()))
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

    func testSearchQuery_atStart_queryShouldBeEmpty() throws {
        // Assert
        XCTAssertEqual(sut.query.value, "")
    }

    func testUpdateSearchQuery_whenPostcodeIsSearched_searchQueryIsUpdated() throws {
        // Arrange
        let searchQuery: String = "ec4m"
        // Act
        MockURLProtocol.stubResponseData = self.getRestaurantData(from: ec4mRestaurantsFilename)
        sut.didSearch(query: searchQuery)
        // Assert
        XCTAssertEqual(searchQuery, sut.query.value)
    }

    func testInitialMessage_atStart_MessageShouldStartMessage() throws {
        // Assert
        XCTAssertEqual(sut.emptyDataTitle, "Search By Postcode")
    }

    func testInitialLoadingState() throws {
        // Assert
        XCTAssertEqual(sut.loading.value, false)
    }

//    func testEmptyResultMessage_whenSearchReturnsEmptyResults_shouldContainCorrectMessage() throws {
//        let searchQuery: String = "ec4m"
//        // Act
//        sut.didSearch(query: searchQuery)
//        // Assert
//        XCTAssertEqual(sut.emptyDataTitle, "Search By Postcode")
//    }

    func testEmptyResultMessage_whenSearchReturnsEmptyResults_emptyFlagShouldBeTrue() throws {
        // Arrange
        let expectation = expectation(description: "Restaurants Expectation")
        MockURLProtocol.stubResponseData = self.getRestaurantData(from: emptySearchResultFilename)
        // Act
        sut.didSearch(query: "")
        sut.error.observe(on: self) { _ in
            // Assert
            XCTAssertTrue(self.sut.isEmpty)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testValidResponseData_whenSearchReturnsValidResults_emptyFlagShouldBeFalse() throws {
        // Arrange
        let expectation = expectation(description: "Restaurants Expectation")
        MockURLProtocol.stubResponseData = self.getRestaurantData(from: ec4mRestaurantsFilename)
        // Act
        sut.didSearch(query: "someSearch")
        sut.openRestaurants.observe(on: self) { _ in
            // Assert
            XCTAssertFalse(self.sut.isEmpty)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testValidResponseData_whenSearchReturnsValidResults_shouldHaveRestaurantsData() throws {
        // Arrange
        let expectation = expectation(description: "Restaurants Expectation")
        MockURLProtocol.stubResponseData = self.getRestaurantData(from: ec4mRestaurantsFilename)
        // Act
        sut.didSearch(query: "")
        sut.openRestaurants.observe(on: self) { _ in
            // Assert
            XCTAssertEqual(self.sut.openRestaurants.value.count, 171)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testEmptyResult_whenSearchReturnsEmptyResults_correctErrorBeDisplayed() throws {
        // Arrange
        let expectation = expectation(description: "Restaurants Expectation")
        MockURLProtocol.stubResponseData = self.getRestaurantData(from: emptySearchResultFilename)
        // Act
        sut.didSearch(query: "")
        sut.error.observe(on: self) { _ in
            // Assert
            XCTAssertTrue(self.sut.isEmpty)
            XCTAssertEqual(self.sut.error.value, "No Results Found for \(self.sut.query.value).\nTry different Code")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

}
