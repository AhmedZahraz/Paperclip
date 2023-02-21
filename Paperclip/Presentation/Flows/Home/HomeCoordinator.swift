//
//  HomeCoordinator.swift
//  Paperclip
//
//  Created by Ahmed Zahraz on 15/02/2023.
//

import UIKit

protocol HomeCoordinatorDependencies {
    func makeAdsListCoordinator(navigationController: UINavigationController) -> AdsListCoordinator
}

class HomeCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    private let dependencies: HomeCoordinatorDependencies

    init(navigationController: UINavigationController,
         dependencies: HomeCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    func start() {
        showAdsList()
    }
    
    func showAdsList() {
        let child = dependencies.makeAdsListCoordinator(navigationController: navigationController)
        //AdsListCoordinator(navigationController: navigationController)
        childCoordinators.append(child)
        child.start()
    }
}
