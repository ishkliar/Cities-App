//
//  DependencyContainer.swift
//  Cities App
//
//  Created by Iaroslav Shkliar on 02/08/2020.
//  Copyright © 2020 Iaroslav Shkliar. All rights reserved.
//

import Foundation

public final class DependencyContainer {

    // MARK: - Private properties

    private var container: [String: Any] = [:]

    // MARK: - Properties

    static let shared = DependencyContainer()

    // MARK: - Methods

    func register<T: Any>(type: T.Type, object: T) {
        container[String(describing: T.self)] = object
    }

    func unregister<T: Any>(type: T.Type) {
        container.removeValue(forKey: String(describing: T.self))
    }

    func resolve<T>(_ type: T.Type) -> T? {
        return container[String(describing: T.self)] as? T
    }
}

@propertyWrapper
struct Inject<T> {
    var wrappedValue: T? {
        DependencyContainer.shared.resolve(T.self)
    }
}
