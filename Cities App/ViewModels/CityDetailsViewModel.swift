//
//  CityDetailsViewModel.swift
//  Cities App
//
//  Created by Iaroslav Shkliar on 02/08/2020.
//  Copyright © 2020 Iaroslav Shkliar. All rights reserved.
//

import UIKit

protocol CityDetailsViewModelCoordinatorDelegate: AnyObject {
    func viewModelDidFinish(_ viewModel: CityDetailsViewModelProtocol)
    func viewModelDidUpdateFavorites(_ viewModel: CityDetailsViewModelProtocol)
    func viewModel(_ viewModel: CityDetailsViewModelProtocol, requstedForPresentVisitorsFor city: City, andVisitors visitors: [Visitor])
}

protocol CityDetailsViewModelViewDelegate: AnyObject {
    func viewModelWillFetchData(_ viewModel: CityDetailsViewModelProtocol)
    func viewModelDidFetchData(_ viewModel: CityDetailsViewModelProtocol)
    func viewModel(_ viewModel: CityDetailsViewModelProtocol, didFinishWithError error: FetchError)
}

protocol CityDetailsViewModelProtocol {
    var title: String { get }
    var ratingText: String { get }
    var photo: UIImage? { get }
    var visitorsText: String { get }
    var isFavorite: Bool { get }

    func fetchData()
    func tapFavorites()
    func tapVisitors()
    func finish()
}

final class CityDetailsViewModel: CityDetailsViewModelProtocol {

    // MARK: - Dependecies

    @Inject private var apiClient: CitiesApiClient?
    @Inject private var favoritesRepository: FavoritesRepositoryProtocol?

    // MARK: - Private properties

    private let fetchDispatchGroup: DispatchGroup? = DispatchGroup()
    private let cityDetails: CityDetails
    private var visitors: [Visitor] = []
    private var ratings: [Rating] = []

    // MARK: - Properties

    var title: String { cityDetails.city.name }
    var photo: UIImage? { cityDetails.photo }
    var ratingText: String {
        let avg = avaregeRating(ratings: ratings.map { $0.value })
        return String(format: NSLocalizedString("Rating: %i / 100", comment: "Label text on city details screen"), avg)
    }

    var visitorsText: String {
        String(format: NSLocalizedString("Show visitors (%i)", comment: "Buttom title on city details screen"), visitors.count)
    }

    var isFavorite: Bool {
        favoritesRepository?.contains(id: cityDetails.city.id) ?? false
    }

    // MARK: - Delegates

    weak var viewDelegate: CityDetailsViewModelViewDelegate?
    weak var coordinatorDelegate: CityDetailsViewModelCoordinatorDelegate?

    // MARK: - Init

    init(cityDetails: CityDetails) {
        self.cityDetails = cityDetails
    }

    // MARK: - Private methods

    private func fetchVisitors() {
        fetchDispatchGroup?.enter()
        apiClient?.request(.cityVisitors(cityId: cityDetails.city.id)) { [weak self] (response: Response<[Visitor]>) in
            guard let self = self else { return }

            switch response {
            case let .success(visitors):
                self.visitors = visitors
            case let .failure(error):
                self.viewDelegate?.viewModel(self, didFinishWithError: error)
            }

            self.fetchDispatchGroup?.leave()
        }
    }

    private func fetchRating() {
        fetchDispatchGroup?.enter()
        apiClient?.request(.cityRatings(cityId: cityDetails.city.id)) { [weak self] (response: Response<[Rating]>) in
            guard let self = self else { return }

            switch response {
            case let .success(ratings):
                self.ratings = ratings
            case let .failure(error):
                self.viewDelegate?.viewModel(self, didFinishWithError: error)
            }

            self.fetchDispatchGroup?.leave()
        }
    }

    private func avaregeRating(ratings: [Int]) -> Int {
        guard ratings.count > 0 else {
            return 0
        }

        let sum = ratings.reduce(.zero, +)
        let avarege = sum / ratings.count

        return avarege
    }

    // MARK: - Methods

    func fetchData() {
        viewDelegate?.viewModelWillFetchData(self)
        fetchVisitors()
        fetchRating()
        fetchDispatchGroup?.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.viewDelegate?.viewModelDidFetchData(self)
        }
    }

    func tapFavorites() {
        if isFavorite {
            favoritesRepository?.remove(id: cityDetails.city.id)
        } else {
            favoritesRepository?.add(id: cityDetails.city.id)
        }

        coordinatorDelegate?.viewModelDidUpdateFavorites(self)
    }

    func tapVisitors() {
        coordinatorDelegate?.viewModel(self, requstedForPresentVisitorsFor: cityDetails.city, andVisitors: visitors)
    }

    func finish() {
        coordinatorDelegate?.viewModelDidFinish(self)
    }
}
