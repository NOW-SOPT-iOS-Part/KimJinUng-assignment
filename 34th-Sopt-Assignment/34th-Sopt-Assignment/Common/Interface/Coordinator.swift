//
//  Coordinator.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 6/2/24.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get }
    
    func start()
}
