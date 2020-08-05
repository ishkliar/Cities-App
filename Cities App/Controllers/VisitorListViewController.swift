//
//  VisitorListViewController.swift
//  Cities App
//
//  Created by Iaroslav Shkliar on 04/08/2020.
//  Copyright © 2020 Iaroslav Shkliar. All rights reserved.
//

import UIKit

class VisitorListViewController: UIViewController, StoryboardInstantiatable {

    // MARK: - Outletes

    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties

    var viewModel: VisitorListViewModelProtocol!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationController()
    }

    // MARK: - Methods

    private func setupNavigationController() {
        title = viewModel.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissAction))
    }

    private func setupUI() {
        tableView.dataSource = self
        tableView.register(UITableViewCell.self)
    }

    @objc func dismissAction() {
        viewModel.finish()
    }
}

extension VisitorListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfItems
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.visitors[indexPath.row]
        let cell: UITableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.textLabel?.text = item.fullName

        return cell
    }
}
