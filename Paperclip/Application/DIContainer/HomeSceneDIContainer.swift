//
//  HomeSceneDIContainer.swift
//  Paperclip
//
//  Created by Ahmed Zahraz on 15/02/2023.
//

import UIKit

final class HomeSceneDIContainer {
    
    struct Dependencies {
        let networkService: NetworkService
        let coreDataService: CoreDateService
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Use Cases
    func makeGetAdsWithCategoriesUseCase() -> GetAdsWithCategoriesUseCase {
        return DefaultGetAdsWithCategoriesUseCase(adRepository: makeAdRepository(),
                                                  categoryRepository: makeCategoryRepository())
    }
    
    func makeGetAdUseCase() -> GetAdUseCase {
        return DefaultGetAdUseCase(adRepository: makeAdRepository())
    }
    
    // MARK: - Repositories
    func makeAdRepository() -> AdRepository {
        return DefaultAdRepository(networkService: dependencies.networkService,
                                   coreDateService: dependencies.coreDataService,
                                   categoryRepository: makeCategoryRepository())
    }
    
    func makeCategoryRepository() -> CategoryRepository {
        return DefaultCategoryRepository(networkService: dependencies.networkService)
    }
    
    // MARK: - Home Coordinator
    func makeHomeCoordinator(navigationController: UINavigationController) -> HomeCoordinator {
        return HomeCoordinator(navigationController: navigationController, dependencies: self)
    }
    
    // MARK: - Ads List
    func makeAdsListCoordinator(navigationController: UINavigationController) -> AdsListCoordinator {
        return AdsListCoordinator(navigationController: navigationController, dependencies: self)
    }
    
    func makeAdsListViewController(coordinator: AdsListCoordinator) -> AdsListViewController {
        return AdsListViewController.create(with: makeAdsListViewModel(), coordintor: coordinator)
    }
    
    func makeAdsListViewModel() -> AdsListViewModel {
        return DefaultAdsListViewModel(getAdsWithCategoriesUseCase: makeGetAdsWithCategoriesUseCase())
    }
    
    // MARK: - Ad Details
    func makeAdDetailsCoordinator(navigationController: UINavigationController, adID: Int64) -> AdDetailsCoordinator {
        return AdDetailsCoordinator(navigationController: navigationController, dependencies: self, adID: adID)
    }
    
    func makeAdDetailsViewController(coordinator: AdDetailsCoordinator, adID: Int64) -> AdDetailsViewController {
        return AdDetailsViewController.create(with: makeAdDetailsViewModel(), coordintor: coordinator, for: adID)
    }
    
    func makeAdDetailsViewModel() -> AdDetailsViewModel {
        return DefaultAdDetailsViewModel(getAdUseCase: makeGetAdUseCase())
    }
}

extension HomeSceneDIContainer: HomeCoordinatorDependencies {}
extension HomeSceneDIContainer: AdsListCoordinatorDependencies {}
extension HomeSceneDIContainer: AdDetailsCoordinatorDependencies {}
