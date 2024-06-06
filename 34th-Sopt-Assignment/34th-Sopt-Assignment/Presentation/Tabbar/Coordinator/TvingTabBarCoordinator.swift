//
//  TvingTabBarCoordinator.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 6/7/24.
//

import UIKit

final class TvingTabBarCoordinator: Coordinator {
    let navigationController: UINavigationController
    let childCoordinators: [Coordinator] = [
        HomeCoordinator(),
        ComingSoonCoordinator(),
        SearchCoordinator(),
        HistoryCoordinator()
    ]
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        start()
    }
    
    func start() {
        let tabBarController = TvingTabBarController(
            viewControllers: childCoordinators.map { $0.navigationController }
        )
        navigationController.setViewControllers([tabBarController], animated: true)
    }
}
