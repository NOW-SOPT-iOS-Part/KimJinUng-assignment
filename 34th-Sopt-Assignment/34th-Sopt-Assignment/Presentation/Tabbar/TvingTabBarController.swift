//
//  TvingTabBarController.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 4/29/24.
//

import UIKit
import Then

final class TvingTabBarController: UITabBarController {
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
}

private extension TvingTabBarController {
    
    // MARK: - SetUI
    
    private func setUI() {
        navigationController?.navigationBar.isHidden = true
        
        tabBar.do {
            $0.backgroundColor = .black
            $0.unselectedItemTintColor = .gray3
            $0.tintColor = .white
            $0.barTintColor = .black
        }
        
        let tabBarItems: [(title: String, image: UIImage?, tag: Int)] = [
            ("홈", UIImage(systemName: "house.fill"), 0),
            ("공개예정", UIImage(systemName: "play.tv.fill"), 1),
            ("검색", UIImage(systemName: "magnifyingglass"), 2),
            ("기록", UIImage(systemName: "stopwatch.fill"), 3)
        ]
        
        let rootViewControllers = [
            HomeViewController(),
            ComingSoonViewController(),
            SearchViewController(),
            HistoryViewController()
        ]
        
        viewControllers = zip(rootViewControllers, tabBarItems).map { viewController, tabBarItemInfo in
            let (title, image, tag) = tabBarItemInfo
            let tabBarItem = UITabBarItem(title: title, image: image, tag: tag)
            viewController.tabBarItem = tabBarItem
            return UINavigationController(rootViewController: viewController)
        }
    }
}
