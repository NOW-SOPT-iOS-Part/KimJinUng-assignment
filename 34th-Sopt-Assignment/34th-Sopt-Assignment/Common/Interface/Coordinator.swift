//
//  Coordinator.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 6/2/24.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get }
    var childCoordinators: [Coordinator] { get }
    
    func start()
}
