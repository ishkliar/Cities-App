//
//  UIAlertAction+DefaultActions.swift
//  Cities App
//
//  Created by Iaroslav Shkliar on 01/08/2020.
//  Copyright © 2020 Iaroslav Shkliar. All rights reserved.
//

import UIKit

public extension UIAlertAction {
    static let ok = UIAlertAction(title: NSLocalizedString("OK", comment: "OK button on alert."), style: .default)
    static let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel button on alert."), style: .cancel)
}
