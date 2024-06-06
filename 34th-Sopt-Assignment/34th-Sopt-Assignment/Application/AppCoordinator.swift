//
//  AppCoordinator.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 6/2/24.
//

import UIKit

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var isLoginSucceed: Bool = false {
        didSet {
            start()
        }
    }
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.navigationBar.isHidden = true
        
        start()
    }
    
    func start() {
        isLoginSucceed ? startMainFlow() : startLoginFlow()
    }
}

extension AppCoordinator {
    func didFinish(_ child: Coordinator) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}

private extension AppCoordinator {
    func startLoginFlow() {
        let coordinator = LoginCoordinator(navigationController: navigationController)
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
    }
    
    func startMainFlow() {
        let coordinator = TvingTabBarCoordinator(navigationController: navigationController)
        childCoordinators.append(coordinator)
    }
}
