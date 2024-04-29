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
    
    private let segmentedControl = UnderlineSegmentedControl(items: ["홈", "실시간", "프로그램", "영화", "파라마운트+"])
    
    private let homeCollectionView = UIView()
    
    private let realTimeView = UIView()
    
    private let tvProgramView = UIView()
    
    private let movieView = UIView()
    
    private let paramountView = UIView()
    
    // MARK: - Property
    
    private var segmentViews: [UIView] {
        [homeCollectionView, realTimeView, tvProgramView, movieView, paramountView]
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setNavigationBar()
        setViewHierarchy()
        setAutoLayout()
    }
    
    // MARK: - Action
    
    @objc
    private func segmentedControlValueChanged(_ sender: UnderlineSegmentedControl) {
        for i in 0..<segmentViews.count {
            segmentViews[i].isHidden = i != sender.selectedSegmentIndex
        }
    }
}

private extension HomeViewController {
    
    // MARK: - SetUI
    
    func setUI() {
        view.backgroundColor = .black
        
        segmentedControl.do {
            $0.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        }
        homeCollectionView.do {
            $0.backgroundColor = .black
        }
        realTimeView.do {
            $0.isHidden = true
            $0.backgroundColor = .gray5
        }
        tvProgramView.do {
            $0.isHidden = true
            $0.backgroundColor = .gray4
        }
        movieView.do {
            $0.isHidden = true
            $0.backgroundColor = .gray3
        }
        paramountView.do {
            $0.isHidden = true
            $0.backgroundColor = .gray2
        }
    }
    
    func setNavigationBar() {
        let leftButton = UIBarButtonItem(
            image: UIImage(resource: .tvingTextLogo).withRenderingMode(.alwaysOriginal),
            style: .plain,
            target: nil,
            action: nil
        ).then {
            $0.isEnabled = false
        }
        let rightButton = UIBarButtonItem(
            image: UIImage(resource: .profileDoosan).withRenderingMode(.alwaysOriginal),
            style: .plain,
            target: nil,
            action: nil
        )
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = rightButton
    }
    
    func setViewHierarchy() {
        view.addSubviews(segmentedControl, homeCollectionView, realTimeView, tvProgramView, movieView, paramountView)
        view.bringSubviewToFront(segmentedControl)
    }
    
    // MARK: - AutoLayout
    
    func setAutoLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        segmentedControl.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(safeArea)
            $0.height.equalTo(40)
        }
        segmentViews.forEach { view in
            view.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
    }
}
