//
//  AppCoordinator.swift
//  Paperclip
//
//  Created by Ahmed Zahraz on 15/02/2023.
//

import UIKit

final class AppCoordinator {

    var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    
    init(navigationController: UINavigationController,
         appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }

    func start() {
        let homeSceneDIContainer = appDIContainer.makeHomeSceneDIContainer()
        let homeFlow = homeSceneDIContainer.makeHomeCoordinator(navigationController: navigationController)
        homeFlow.start()
    }
}
