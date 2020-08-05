//
//  VisitorListViewModel.swift
//  Cities App
//
//  Created by Iaroslav Shkliar on 04/08/2020.
//  Copyright © 2020 Iaroslav Shkliar. All rights reserved.
//

import Foundation

protocol VisitorListCoordinatorDelegate: AnyObject {
    func viewModelDidFinish(_ viewModel: VisitorListViewModelProtocol)
}

protocol VisitorListViewModelProtocol {
    var title: String { get }
    var numberOfItems: Int { get }
    var visitors: [Visitor] { get }

    func finish()
}

final class VisitorListViewModel: VisitorListViewModelProtocol {

    // MARK: - Properties

    var title: String { city.name + " " + NSLocalizedString("Visitors", comment: "Title on visitors list screen") }
    var numberOfItems: Int { visitors.count }
    var visitors: [Visitor]
    let city: City

    // MARK: - Delegates

    weak var coordinatorDelegate: VisitorListCoordinatorDelegate?

    // MARK: - Init

    init(city: City, visitors: [Visitor]) {
        self.visitors = visitors
        self.city = city
    }

    // MARK: - Methods

    func finish() {
        coordinatorDelegate?.viewModelDidFinish(self)
    }
}
