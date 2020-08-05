//
//  AlertPresentable.swift
//  Cities App
//
//  Created by Iaroslav Shkliar on 01/08/2020.
//  Copyright © 2020 Iaroslav Shkliar. All rights reserved.
//

import UIKit

public protocol AlertPresentable {
    func presentAlert(title: String?, message: String?, actions: [UIAlertAction], alertStyle: UIAlertController.Style, handler: (() -> Void)?)
}

public extension AlertPresentable where Self: UIViewController {
    func presentAlert(title: String?,
                      message: String?,
                      actions: [UIAlertAction] = [.ok],
                      alertStyle: UIAlertController.Style = .alert,
                      handler: (() -> Void)? = nil) {

        let alert = UIAlertController(title: title, message: message, preferredStyle: alertStyle)
        actions.forEach { alert.addAction($0) }

        present(alert, animated: true, completion: handler)
    }

    func presentAlert(fetchError: FetchError, actions: [UIAlertAction] = [.ok], alertStyle: UIAlertController.Style = .alert, handler: (() -> Void)? = nil) {
        let title = NSLocalizedString("Oops!", comment: "Generic error title")
        let alert = UIAlertController(title: title, message: fetchError.localizedDescription, preferredStyle: UIAlertController.Style.alert)
        actions.forEach { alert.addAction($0) }

        present(alert, animated: true, completion: handler)
    }
}
