//
//  UITableVIew+Extension.swift
//  Cities App
//
//  Created by Iaroslav Shkliar on 03/08/2020.
//  Copyright © 2020 Iaroslav Shkliar. All rights reserved.
//

import UIKit

public extension UITableView {
    func register<T: UITableViewCell>(_: T.Type) where T: NibInstantiatable {
        let nib = UINib(nibName: T.nibName, bundle: .main)
        register(nib, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }

    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }

        return cell
    }
}
