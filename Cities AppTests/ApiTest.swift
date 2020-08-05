//
//  ApiTest.swift
//  Cities AppTests
//
//  Created by Iaroslav Shkliar on 04/08/2020.
//  Copyright © 2020 Iaroslav Shkliar. All rights reserved.
//

import Foundation

@testable import Cities_App
import XCTest

class ApiTest: XCTestCase {

    var sut: CitiesApiClient!

    override func setUp() {
        super.setUp()
        sut = CitiesApiClient()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testCitiesEnpoint() {
        let expectation = XCTestExpectation(description: "Fetch list of cities")

        sut.request(.cityList) { (response: Response<[City]>) in
            XCTAssertNotNil(response.value)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func testVisitorsEnpoint() {
        let expectation = XCTestExpectation(description: "Fetch list of visitors")

        sut.request(.cityVisitors(cityId: "1")) { (response: Response<[Visitor]>) in
            XCTAssertNotNil(response.value)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func testRatingsEnpoint() {
        let expectation = XCTestExpectation(description: "Fetch list of ratings")

        sut.request(.cityRatings(cityId: "1")) { (response: Response<[Rating]>) in
            XCTAssertNotNil(response.value)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }
}
