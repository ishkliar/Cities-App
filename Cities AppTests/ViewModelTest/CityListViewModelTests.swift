//
//  CityListViewModel_Tests.swift
//  Cities AppTests
//
//  Created by Iaroslav Shkliar on 04/08/2020.
//  Copyright © 2020 Iaroslav Shkliar. All rights reserved.
//

@testable import Cities_App
import XCTest

class CityListViewModelTests: BaseTestCase {

    var sut: CityListViewModel!

    override func setUp() {
        super.setUp()
        sut = CityListViewModel()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testNumberOfItemsAfterFetch() throws {
        // When
        sut.fetchData()

        // Assert
        XCTAssertEqual(sut.numberOfItems, 3)
    }

    func testNumberOfItemsFilterByFavorite() throws {
        // When
        sut.fetchData()
        sut.tapFavorites()

        // Assert
        XCTAssertEqual(sut.numberOfItems, 1)
    }

    func testFavoriteItem() throws {
        // When
        sut.fetchData()
        sut.tapFavorites()

        // Given
        let item = sut.item(at: 0)

        // Assert
        XCTAssertEqual(item.title, "Test city 2")
    }

    func testFlagShowFavoriteIsToggledProperly() {
        // When
        sut.fetchData()
        sut.tapFavorites()

        // Assert
        XCTAssertTrue(sut.showFavorites)

        // Then
        sut.tapFavorites()

        // Assert
        XCTAssertFalse(sut.showFavorites)
    }
}
