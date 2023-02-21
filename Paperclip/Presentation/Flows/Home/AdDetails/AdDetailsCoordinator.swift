//
//  AdDetailsCoordinator.swift
//  Paperclip
//
//  Created by Ahmed Zahraz on 18/02/2023.
//

import UIKit

protocol AdDetailsCoordinatorDependencies {
    func makeAdDetailsViewController(coordinator: AdDetailsCoordinator, adID: Int64) -> AdDetailsViewController
}

class AdDetailsCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    private let dependencies: AdDetailsCoordinatorDependencies
    private let adID: Int64
    
    init(navigationController: UINavigationController,
         dependencies: AdDetailsCoordinatorDependencies,
         adID: Int64) {
        self.navigationController = navigationController
        self.dependencies = dependencies
        self.adID = adID
    }

    func start() {
        let vc = dependencies.makeAdDetailsViewController(coordinator: self, adID: self.adID)
        navigationController.pushViewController(vc, animated: true)
    }
}
