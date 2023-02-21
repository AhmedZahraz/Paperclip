//
//  AdsListCoordinator.swift
//  Paperclip
//
//  Created by Ahmed Zahraz on 15/02/2023.
//

import UIKit

protocol AdsListCoordinatorDependencies {
    func makeAdsListViewController(coordinator: AdsListCoordinator) -> AdsListViewController
    func makeAdDetailsCoordinator(navigationController: UINavigationController, adID: Int64) -> AdDetailsCoordinator
}

class AdsListCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    private let dependencies: AdsListCoordinatorDependencies
    
    init(navigationController: UINavigationController,
         dependencies: AdsListCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    func start() {
        let vc = dependencies.makeAdsListViewController(coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showAdDetails(with adID: Int64) {
        let child = dependencies.makeAdDetailsCoordinator(navigationController: navigationController, adID: adID)
        childCoordinators.append(child)
        child.start()
    }
    
    func showError(title: String? = NSLocalizedString("error_title", comment: ""),
                   message: String? = NSLocalizedString("error_general_message", comment: ""),
                   retryTitle: String? = NSLocalizedString("retry_button_title", comment: ""),
                   hideTitle: String? = NSLocalizedString("hide_button_title", comment: ""),
                   onRetry: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: retryTitle, style: .default, handler: onRetry))
        alert.addAction(UIAlertAction(title: hideTitle, style: .default, handler: nil))
        navigationController.present(alert, animated: true, completion: nil)
    }
}
