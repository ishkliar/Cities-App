//
//  MockFavoritesRepository.swift
//  Cities AppTests
//
//  Created by Iaroslav Shkliar on 04/08/2020.
//  Copyright © 2020 Iaroslav Shkliar. All rights reserved.
//

import Foundation

class MockFavoritesRepository: FavoritesRepositoryProtocol {

    private var favorites: Set<String> = []

    func add(id: String) {
        favorites.insert(id)
    }

    func remove(id: String) {
        if favorites.contains(id) {
            favorites.remove(id)
        }
    }

    func contains(id: String) -> Bool {
        favorites.contains(id)
    }
}
