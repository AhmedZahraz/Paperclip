//
//  Coordinator.swift
//  Paperclip
//
//  Created by Ahmed Zahraz on 15/02/2023.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}
