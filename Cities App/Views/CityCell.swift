//
//  CityTableViewCell.swift
//  Cities App
//
//  Created by Iaroslav Shkliar on 03/08/2020.
//  Copyright © 2020 Iaroslav Shkliar. All rights reserved.
//

import UIKit

final class CityCell: UITableViewCell, NibInstantiatable {

    // MARK: - Outlets

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var favoriteIcon: UIImageView!

    // MARK: - Private properties

    private var viewModel: CityCellViewModel?

    // MARK: - Lifecycle

    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel?.cancelRetrieving()
        thumbnailImageView.image = nil
    }

    // MARK: - Methods

    func configureCell(with viewModel: CityCellViewModel) {
        self.viewModel = viewModel
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        favoriteIcon.isHidden = !viewModel.isFavorite
    }
}
