//
//  NSLayoutConstraint+Extension.swift
//  Cities App
//
//  Created by Iaroslav Shkliar on 04/08/2020.
//  Copyright © 2020 Iaroslav Shkliar. All rights reserved.
//

import UIKit

public extension NSLayoutConstraint {
    static func center(_ subview: UIView, in view: UIView, for axises: [Axis] = [.vertical, .horizontal], with offset: CGPoint = .zero) {
        for axis in axises {
            switch axis {
            case .vertical:
                subview.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: offset.y).isActive = true
            case .horizontal:
                subview.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: offset.x).isActive = true
            default:
                break
            }
        }
    }
}
