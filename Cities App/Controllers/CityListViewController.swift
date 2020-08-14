//
//  CityListViewController.swift
//  Cities App
//
//  Created by Iaroslav Shkliar on 01/08/2020.
//  Copyright © 2020 Iaroslav Shkliar. All rights reserved.
//

import UIKit

class CityListViewController: BaseViewController, StoryboardInstantiatable, AlertPresentable {

    // MARK: - Outlets

    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties

    var viewModel: CityListViewModelProtocol!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationController()
        viewModel.fetchData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let selectionIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectionIndexPath, animated: animated)
        }

        tableView.reloadData()
    }

    // MARK: - Private methods

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()

        tableView.register(CityCell.self)
    }

    private func setupNavigationController() {
        title = viewModel.title
        setupFavoriteButton()
    }

    private func setupFavoriteButton() {
        let favorite = viewModel.showFavorites ? #imageLiteral(resourceName: "baseline_favorite_black_24pt") : #imageLiteral(resourceName: "baseline_favorite_border_black_24pt")
        let favoriteBarItem = UIBarButtonItem(image: favorite, style: .plain, target: self, action: #selector(favoritesAction))
        navigationItem.rightBarButtonItem = favoriteBarItem
    }

    @objc private func favoritesAction() {
        viewModel.tapFavorites()
        setupFavoriteButton()
    }
}

extension CityListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellViewModel = viewModel.item(at: indexPath.row)
        let cell: CityCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configureCell(with: cellViewModel)
        cell.imageView?.image = nil

        cellViewModel.retrieveImage { image in
            let cell = tableView.cellForRow(at: indexPath) as? CityCell
            cell?.thumbnailImageView.image = image
        }

        return cell
    }
}

extension CityListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectItem(at: indexPath.row)
    }
}

extension CityListViewController: CityListViewModelViewDelegate {
    func viewModelWillFetchData(_ viewModel: CityListViewModel) {
        isLoading = true
    }

    func viewModelDidFetchData(_ viewModel: CityListViewModel) {
        isLoading = false
        tableView.reloadData()
    }

    func viewModel(_ viewModel: CityListViewModel, didFinishWithError error: FetchError) {
        isLoading = false
        presentAlert(fetchError: error)
    }
}
