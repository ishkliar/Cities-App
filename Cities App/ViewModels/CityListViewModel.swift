//
//  CityListViewModel.swift
//  Cities App
//
//  Created by Iaroslav Shkliar on 01/08/2020.
//  Copyright © 2020 Iaroslav Shkliar. All rights reserved.
//

import Foundation

protocol CityListViewModelCoordinatorDelegate: AnyObject {
    func viewModel(_ viewModel: CityListViewModelProtocol, requstedForPresentCityDetailsFor cityDetails: CityDetails)
}

protocol CityListViewModelViewDelegate: AnyObject {
    func viewModelWillFetchData(_ viewModel: CityListViewModel)
    func viewModelDidFetchData(_ viewModel: CityListViewModel)
    func viewModel(_ viewModel: CityListViewModel, didFinishWithError error: FetchError)
}

protocol CityListViewModelProtocol {
    var title: String { get }
    var numberOfItems: Int { get }
    var showFavorites: Bool { get set }

    func fetchData()
    func item(at index: Int) -> CityCellViewModel
    func selectItem(at index: Int)
    func tapFavorites()
}

final class CityListViewModel: CityListViewModelProtocol {

    // MARK: - Dependecies

    @Inject private var apiClient: CitiesApiClient?
    @Inject private var favoritesRepository: FavoritesRepositoryProtocol?

    // MARK: - Private properties

    private var items: [CityCellViewModel] = []
    private var cityList: [City] = []

    // MARK: - Properties

    let title = NSLocalizedString("City list", comment: "Title on city list screen")
    var numberOfItems: Int { items.count }
    var showFavorites: Bool = false

    // MARK: - Delegates

    weak var viewDelegate: CityListViewModelViewDelegate?
    weak var coordinatorDelegate: CityListViewModelCoordinatorDelegate?

    // MARK: - Methods

    func fetchData() {
        viewDelegate?.viewModelWillFetchData(self)
        apiClient?.request(.cityList) { [weak self] (response: Response<[City]>) in
            guard let self = self else { return }

            switch response {
            case let .success(cityList):
                self.cityList = cityList.sorted { $0.name < $1.name }
                self.prepareItems()
                self.viewDelegate?.viewModelDidFetchData(self)
            case let .failure(error):
                self.viewDelegate?.viewModel(self, didFinishWithError: error)
            }
        }
    }

    func item(at index: Int) -> CityCellViewModel {
        return items[index]
    }

    func selectItem(at index: Int) {
        let viewModel = items[index]
        guard let city = cityList.first(where: { $0.id == viewModel.id }) else { return }

        viewModel.retrieveImage { [weak self] image in
            guard let self = self else { return }
            let cityDetails = CityDetails(city: city, photo: image)
            self.coordinatorDelegate?.viewModel(self, requstedForPresentCityDetailsFor: cityDetails)
        }
    }

    func tapFavorites() {
        showFavorites.toggle()
        prepareItems()
        viewDelegate?.viewModelDidFetchData(self)
    }

    func prepareItems() {
        let items = cityList.map {
            CityCellViewModel(city: $0, isFavorite: favoritesRepository?.contains(id: $0.id) ?? false)
        }

        self.items = showFavorites ? items.filter { $0.isFavorite } : items
    }
}
