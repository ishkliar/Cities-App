//
//  BaseViewController.swift
//  Cities App
//
//  Created by Iaroslav Shkliar on 04/08/2020.
//  Copyright © 2020 Iaroslav Shkliar. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    // MARK: - Private properties

    private let activityIndicator = UIActivityIndicatorView()

    // MARK: - Properties

    var isLoading: Bool = false {
        didSet {
            if isLoading {
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        NSLayoutConstraint.center(activityIndicator, in: view)
    }
}
