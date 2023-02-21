//
//  AppDIContainer.swift
//  Paperclip
//
//  Created by Ahmed Zahraz on 15/02/2023.
//

import Foundation

final class AppDIContainer {
    
    // MARK: - Network
    lazy var networkService: NetworkService = DefaultNetworkService(client: URLSession.shared, logger: DefaultNetworkLogger())
    
    // MARK: - LocalStorage
    lazy var coreDataService: CoreDateService = CoreDateService(dataModelName: "DataModel")
    
    // MARK: - DIContainers of scenes
    func makeHomeSceneDIContainer() -> HomeSceneDIContainer {
        let dependencies = HomeSceneDIContainer.Dependencies(networkService: networkService,
                                                             coreDataService: coreDataService)
        
        return HomeSceneDIContainer(dependencies: dependencies)
    }
}
