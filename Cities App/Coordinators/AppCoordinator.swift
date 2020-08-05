//
//  AppCoordinator.swift
//  Cities App
//
//  Created by Iaroslav Shkliar on 01/08/2020.
//  Copyright © 2020 Iaroslav Shkliar. All rights reserved.
//

import UIKit

final class AppCoordinator: Coordinator {

    // MARK: - Private properties

    private let window: UIWindow
    private let cityListViewModel = CityListViewModel()

    // MARK: - Properties

    var components: CoordinatorComponents
    weak var delegate: CoordinatorDelegate?

    // MARK: - Init

    init(window: UIWindow) {
        self.window = window
        components = CoordinatorComponents()
    }

    // MARK: - Methods

    func start() {
        let cityListViewController = CityListViewController.instantiate()

        cityListViewModel.viewDelegate = cityListViewController
        cityListViewModel.coordinatorDelegate = self
        cityListViewController.viewModel = cityListViewModel

        let navigationController = components.rootNavigationController
        navigationController.viewControllers = [cityListViewController]

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}

extension AppCoordinator: CoordinatorDelegate {
    func coordinatorDidFinish(_ coordinator: Coordinator) {
        removeChildCoordinator(coordinator)
    }
}

extension AppCoordinator: CityListViewModelCoordinatorDelegate {
    func viewModel(_ viewModel: CityListViewModelProtocol, requstedForPresentCityDetailsFor cityDetails: CityDetails) {
        let cityDetailsCoordinator = CityDetailsCoordinator(rootNavigationController: components.rootNavigationController, cityDetails: cityDetails)
        cityDetailsCoordinator.delegate = self
        cityDetailsCoordinator.coordinatoreDelegate = self
        cityDetailsCoordinator.start()

        addChildCoordinator(cityDetailsCoordinator)
    }
}

extension AppCoordinator: CityDetailsCoordinatorDelegate {
    func didUpdateFavorites() {
        cityListViewModel.prepareItems()
    }
}
