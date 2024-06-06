//
//  HistoryCoordinator.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 6/7/24.
//

import UIKit

final class HistoryCoordinator: Coordinator {
    let navigationController: UINavigationController
    
    var childCoordinators = [Coordinator]()
    
    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
        
        start()
    }
    
    func start() {
        let viewController = HistoryViewController()
        navigationController.pushViewController(viewController, animated: false)
    }
}
