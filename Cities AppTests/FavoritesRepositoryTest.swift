//
//  FavoritesRepositoryTest.swift
//  Cities AppTests
//
//  Created by Iaroslav Shkliar on 04/08/2020.
//  Copyright © 2020 Iaroslav Shkliar. All rights reserved.
//

@testable import Cities_App
import XCTest

class UserDefaultsFavoritesRepositoryTest: XCTestCase {

    let sut = UserDefaultsFavoritesRepository()

    override func tearDown() {
        sut.removeAll()
        super.tearDown()
    }

    func testAddId() {
        // Given id

        let id = "test_id"

        // When
        sut.add(id: id)

        // Assert
        XCTAssertTrue(sut.contains(id: id))
    }

    func testRemoveId() {
        // Given id

        let id = "test_id"

        // When
        sut.add(id: id)

        // Then
        sut.remove(id: id)

        // Assert
        XCTAssertFalse(sut.contains(id: id))
    }
}
