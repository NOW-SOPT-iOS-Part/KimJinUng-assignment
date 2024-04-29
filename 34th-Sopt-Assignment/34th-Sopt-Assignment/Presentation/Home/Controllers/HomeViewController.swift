//
//  HomeViewController.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 4/29/24.
//

import UIKit
import Then
import SnapKit

final class HomeViewController: UIViewController {
    
    // MARK: - UIComponent
    
    
    // MARK: - Property
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setViewHierarchy()
        setAutoLayout()
    }
    
    // MARK: - Action
    
    
}

private extension HomeViewController {
    
    // MARK: - SetUI
    
    func setUI() {
        view.backgroundColor = .black
        
    }
    
    func setViewHierarchy() {
        
    }
    
    // MARK: - AutoLayout
    
    func setAutoLayout() {
        let safeArea = view.safeAreaLayoutGuide
    }
}
