//
//  HomeCoordinator.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 6/7/24.
//

import UIKit

final class HomeCoordinator: Coordinator {
    let navigationController: UINavigationController
    
    var childCoordinators = [Coordinator]()
    
    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
        
        start()
    }
    
    func start() {
        let viewModel = HomeViewModel()
        let viewController = HomeViewController(viewModel: viewModel)
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: false)
    }
}

extension HomeCoordinator {
    func pushToFind() {
        let boxOfficeService = DefaultNetworkService<BoxOfficeTargetType>()
        let findViewModel = FindViewModel(boxOfficeService: boxOfficeService)
        let findViewController = FindViewController(viewModel: findViewModel)
        navigationController.pushViewController(findViewController, animated: true)
    }
}
