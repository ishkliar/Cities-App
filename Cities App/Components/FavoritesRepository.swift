//
//  FavoritesRepository.swift
//  Cities App
//
//  Created by Iaroslav Shkliar on 03/08/2020.
//  Copyright © 2020 Iaroslav Shkliar. All rights reserved.
//

import Foundation

protocol FavoritesRepositoryProtocol {
    func add(id: String)
    func remove(id: String)
    func contains(id: String) -> Bool
}

final class UserDefaultsFavoritesRepository: FavoritesRepositoryProtocol {

    // MARK: - Private properties

    @UserDefault(key: "Favorites", defaultValue: [String]())
    private var persistent: [String]? // I use an array here because for some reason I couldn't save Set<String> directly to the UserDefaults, but it still faster than encoding to JSON.

    private lazy var favorites: Set<String> = {
        Set<String>(persistent ?? [])
    }()

    // MARK: - Methods

    func add(id: String) {
        favorites.insert(id)
        save()
    }

    func remove(id: String) {
        if favorites.contains(id) {
            favorites.remove(id)
            save()
        }
    }

    func contains(id: String) -> Bool {
        favorites.contains(id)
    }

    func removeAll() {
        favorites = []
        save()
    }

    // MARK: - Private methods

    private func save() {
        persistent = Array(favorites)
    }
}
