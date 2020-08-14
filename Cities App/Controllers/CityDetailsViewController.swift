//
//  CityDetailsViewController.swift
//  Cities App
//
//  Created by Iaroslav Shkliar on 02/08/2020.
//  Copyright © 2020 Iaroslav Shkliar. All rights reserved.
//

import UIKit

class CityDetailsViewController: BaseViewController, StoryboardInstantiatable, AlertPresentable {

    // MARK: - Outlets

    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var showVisitorsButton: UIButton!

    // MARK: - Actions

    @IBAction func showVisitorsAction() {
        viewModel.tapVisitors()
    }

    // MARK: - Properties

    var viewModel: CityDetailsViewModelProtocol!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        viewModel.fetchData()
    }

    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        if parent == nil {
            viewModel.finish()
        }
    }
    
    // MARK: - Private methods

    private func updateUI() {
        ratingLabel.text = viewModel.ratingText
        photoImageView.image = viewModel.photo

        // Prevents UIButton from flashing when updating the title
        UIView.performWithoutAnimation {
            showVisitorsButton.setTitle(viewModel.visitorsText, for: .normal)
            showVisitorsButton.layoutIfNeeded()
        }

        ratingLabel.isHidden = false
        photoImageView.isHidden = false
        showVisitorsButton.isHidden = false
    }

    private func setupNavigationController() {
        title = viewModel.title
        setupFavoriteButton()
    }

    private func setupFavoriteButton() {
        let favorite = viewModel.isFavorite ? #imageLiteral(resourceName: "baseline_favorite_black_24pt") : #imageLiteral(resourceName: "baseline_favorite_border_black_24pt")
        let favoriteBarItem = UIBarButtonItem(image: favorite, style: .plain, target: self, action: #selector(favoritesAction))
        navigationItem.rightBarButtonItem = favoriteBarItem
    }

    @objc private func favoritesAction() {
        viewModel.tapFavorites()
        setupFavoriteButton()
    }
}

extension CityDetailsViewController: CityDetailsViewModelViewDelegate {
    func viewModelWillFetchData(_ viewModel: CityDetailsViewModelProtocol) {
        isLoading = true
    }

    func viewModelDidFetchData(_ viewModel: CityDetailsViewModelProtocol) {
        isLoading = false
        updateUI()
    }

    func viewModel(_ viewModel: CityDetailsViewModelProtocol, didFinishWithError error: FetchError) {
        isLoading = false
        presentAlert(fetchError: error)
    }
}
