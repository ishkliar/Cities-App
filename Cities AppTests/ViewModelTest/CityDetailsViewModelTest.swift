//
//  CityDetailsViewModelTest.swift
//  Cities AppTests
//
//  Created by Iaroslav Shkliar on 04/08/2020.
//  Copyright © 2020 Iaroslav Shkliar. All rights reserved.
//

@testable import Cities_App
import XCTest

class CityDetailsViewModelTest: BaseTestCase {

    var sut: CityDetailsViewModel!

    override func setUp() {
        super.setUp()

        let url = URL(string: "http://url.com")!
        let city = City(id: "1", name: "Test city 1", country: "Test coutry 1", image: url)
        let cityDetails = CityDetails(city: city, photo: nil)

        sut = CityDetailsViewModel(cityDetails: cityDetails)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testAddToFavorite() {
        // When
        sut.tapFavorites()

        // Assert
        XCTAssertEqual(sut.isFavorite, true)
    }

    func testRatingText() {
        // When
        sut.fetchData()

        // Assert
        XCTAssertEqual(sut.ratingText, "Rating: 36 / 100")
    }

    func testVisitorsText() {
        // When
        sut.fetchData()

        // Assert
        XCTAssertEqual(sut.visitorsText, "Show visitors (3)")
    }
}
