//
//  TvingTabBarController.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 4/29/24.
//

import UIKit

import Then

final class TvingTabBarController: UITabBarController {
    
    // MARK: - Initializer
    
    init(viewControllers: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)
        
        configureViewControllers(viewControllers)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.do {
            $0.backgroundColor = .black
            $0.unselectedItemTintColor = .gray3
            $0.tintColor = .white
            $0.barTintColor = .black
        }
    }
}

private extension TvingTabBarController {
    func configureViewControllers(_ viewControllers: [UIViewController]) {
        let tabBarItems: [(title: String, image: UIImage?, tag: Int)] = [
            ("홈", UIImage(systemName: "house.fill"), 0),
            ("공개예정", UIImage(systemName: "play.tv.fill"), 1),
            ("검색", UIImage(systemName: "magnifyingglass"), 2),
            ("기록", UIImage(systemName: "stopwatch.fill"), 3)
        ]
        
        self.viewControllers = zip(viewControllers, tabBarItems)
            .map { viewController, tabBarItemInfo in
                let (title, image, tag) = tabBarItemInfo
                let tabBarItem = UITabBarItem(title: title, image: image, tag: tag)
                viewController.tabBarItem = tabBarItem
                return viewController
            }
    }
}
