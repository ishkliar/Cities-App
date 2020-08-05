//
//  Coordinator.swift
//  Cities App
//
//  Created by Iaroslav Shkliar on 01/08/2020.
//  Copyright © 2020 Iaroslav Shkliar. All rights reserved.
//

import UIKit

public protocol CoordinatorDelegate: AnyObject {
    func coordinatorDidFinish(_ coordinator: Coordinator)
}

public final class CoordinatorComponents {
    fileprivate var childCoordinators: [Coordinator] = []
    public let rootNavigationController: UINavigationController

    public init(rootNavigationController: UINavigationController = UINavigationController()) {
        self.rootNavigationController = rootNavigationController
    }
}

public protocol Coordinator: AnyObject {
    var components: CoordinatorComponents { get set }
    var delegate: CoordinatorDelegate? { get set }

    func start()
    func finish()
}

public extension Coordinator {
    func finish() {
        delegate?.coordinatorDidFinish(self)
    }

    func addChildCoordinator(_ coordinator: Coordinator) {
        components.childCoordinators.append(coordinator)
    }

    func removeChildCoordinator(_ coordinator: Coordinator) {
        guard let index = components.childCoordinators.firstIndex(where: { $0 === coordinator }) else {
            return
        }

        components.childCoordinators.remove(at: index)
    }
}
