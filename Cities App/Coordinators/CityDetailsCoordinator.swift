//
//  CityDetailsCoordinator.swift
//  Cities App
//
//  Created by Iaroslav Shkliar on 03/08/2020.
//  Copyright © 2020 Iaroslav Shkliar. All rights reserved.
//

import UIKit

protocol CityDetailsCoordinatorDelegate: AnyObject {
    func didUpdateFavorites()
}

final class CityDetailsCoordinator: Coordinator {

    // MARK: - Private properties

    private let cityDetails: CityDetails

    // MARK: - Properties

    var components: CoordinatorComponents
    weak var delegate: CoordinatorDelegate?
    weak var coordinatoreDelegate: CityDetailsCoordinatorDelegate?

    // MARK: - Init

    init(rootNavigationController: UINavigationController, cityDetails: CityDetails) {
        components = CoordinatorComponents(rootNavigationController: rootNavigationController)
        self.cityDetails = cityDetails
    }

    // MARK: - Methods

    func start() {
        let cityDetailsViewController = CityDetailsViewController.instantiate()
        let cityDetailsViewModel = CityDetailsViewModel(cityDetails: cityDetails)
        cityDetailsViewModel.viewDelegate = cityDetailsViewController
        cityDetailsViewModel.coordinatorDelegate = self
        cityDetailsViewController.viewModel = cityDetailsViewModel

        components.rootNavigationController.pushViewController(cityDetailsViewController, animated: true)
    }
}

extension CityDetailsCoordinator: CityDetailsViewModelCoordinatorDelegate {
    func viewModelDidUpdateFavorites(_ viewModel: CityDetailsViewModelProtocol) {
        coordinatoreDelegate?.didUpdateFavorites()
    }

    func viewModel(_ viewModel: CityDetailsViewModelProtocol, requstedForPresentVisitorsFor city: City, andVisitors visitors: [Visitor]) {
        let visitorsViewController = VisitorListViewController.instantiate()
        let navigationController = UINavigationController(rootViewController: visitorsViewController)
        let visitorsViewModel = VisitorListViewModel(city: city, visitors: visitors)
        visitorsViewModel.coordinatorDelegate = self
        visitorsViewController.viewModel = visitorsViewModel

        components.rootNavigationController.present(navigationController, animated: true)
    }

    func viewModelDidFinish(_ viewModel: CityDetailsViewModelProtocol) {
        finish()
    }
}

extension CityDetailsCoordinator: VisitorListCoordinatorDelegate {
    func viewModelDidFinish(_ viewModel: VisitorListViewModelProtocol) {
        components.rootNavigationController.dismiss(animated: true)
    }
}
