//
//  AppDelegate.swift
//  Cities App
//
//  Created by Iaroslav Shkliar on 01/08/2020.
//  Copyright © 2020 Iaroslav Shkliar. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Properties

    var window: UIWindow?
    var appCoordinator: AppCoordinator!

    // MARK: - Methods

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window

        setupDependencies()

        appCoordinator = AppCoordinator(window: window)
        appCoordinator.start()

        return true
    }

    // MARK: - Private methods

    private func setupDependencies() {
        let apiClient: CitiesApiClient = ApiProvider()
        let favoritesRepository = UserDefaultsFavoritesRepository()

        DependencyContainer.shared.register(type: CitiesApiClient.self, object: apiClient)
        DependencyContainer.shared.register(type: FavoritesRepositoryProtocol.self, object: favoritesRepository)
    }
}
