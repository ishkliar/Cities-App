//
//  NibInstantiatable.swift
//  Cities App
//
//  Created by Iaroslav Shkliar on 03/08/2020.
//  Copyright © 2020 Iaroslav Shkliar. All rights reserved.
//

import UIKit

public protocol ReusableView: class {
    static var defaultReuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    public static var defaultReuseIdentifier: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}

extension UITableViewCell: ReusableView {}

public protocol NibInstantiatable: AnyObject {
    static var nibName: String { get }
}

extension NibInstantiatable {
    public static var nibName: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}

extension NibInstantiatable where Self: UIView {
    static func loadFromXib() -> Self? {
        return Bundle.main.loadNibNamed(Self.nibName, owner: self, options: nil)?.first as? Self
    }
}
