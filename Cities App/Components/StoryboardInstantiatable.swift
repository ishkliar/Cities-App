//
//  StoryboardInitializable.swift
//  Cities App
//
//  Created by Iaroslav Shkliar on 01/08/2020.
//  Copyright © 2020 Iaroslav Shkliar. All rights reserved.
//

import UIKit

public protocol StoryboardInstantiatable: class {
    static var storyboardName: String { get }
    static var storyboardId: String { get }
}

public extension StoryboardInstantiatable where Self: UIViewController {
    static var storyboardName: String {
        let viewControllerNameSuffix = "ViewController"
        let viewControllerName = String(describing: Self.self)

        guard viewControllerName.hasSuffix(viewControllerNameSuffix) else {
            return viewControllerName
        }

        return String(viewControllerName.dropLast(viewControllerNameSuffix.count))
    }

    static var storyboardId: String {
        return String(describing: Self.self)
    }

    static func instantiate() -> Self {
        let storyboard = UIStoryboard(name: Self.storyboardName, bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: Self.storyboardId) as! Self
    }
}
