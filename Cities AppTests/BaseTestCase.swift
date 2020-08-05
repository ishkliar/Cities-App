//
//  BaseTestCase.swift
//  Cities AppTests
//
//  Created by Iaroslav Shkliar on 04/08/2020.
//  Copyright © 2020 Iaroslav Shkliar. All rights reserved.
//

@testable import Cities_App
import XCTest

class BaseTestCase: XCTestCase {
    override func setUp() {
        super.setUp()

        let mockApiClient = CitiesApiClient(testMode: true)
        let mockFavoritesRepository = MockFavoritesRepository()
        mockFavoritesRepository.add(id: "2")

        DependencyContainer.shared.register(type: CitiesApiClient.self, object: mockApiClient)
        DependencyContainer.shared.register(type: FavoritesRepositoryProtocol.self, object: mockFavoritesRepository)
    }

    override func tearDown() {
        super.tearDown()
        DependencyContainer.shared.unregister(type: CitiesApiClient.self)
        DependencyContainer.shared.unregister(type: FavoritesRepositoryProtocol.self)
    }
}
