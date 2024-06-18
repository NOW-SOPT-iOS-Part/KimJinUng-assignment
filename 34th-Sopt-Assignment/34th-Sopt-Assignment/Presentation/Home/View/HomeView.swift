//
//  HomeView.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 6/19/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class HomeView: UIView {
    
    // MARK: - Component
    
    lazy var homeCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: configureCompositionalLayout()
    )
    
    private let topBackgroundView = UIView(backgroundColor: .clear)
    private let segmentedControl = UnderlineSegmentedControl(
        items: ["홈", "실시간", "프로그램", "영화", "파라마운트+"]
    )
    private let realTimeView = UIView(backgroundColor: .gray4)
    private let tvProgramView = UIView(backgroundColor: .gray3)
    private let movieView = UIView(backgroundColor: .gray2)
    private let paramountView = UIView(backgroundColor: .gray1)
    
    // MARK: - Property
    
    private var segmentViews: [UIView] {
        [homeCollectionView, realTimeView, tvProgramView, movieView, paramountView]
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setViewHierarchy()
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateSegmentView(_ index: Int) {
        for (i, view) in segmentViews.enumerated() {
            view.isHidden = i != index
        }
    }
    
    func updateTopBackgroundColor(_ condition: Bool) {
        topBackgroundView.backgroundColor = condition ? .clear : .black
    }
}

extension HomeView {
    var selectedSegmentIndexChanged: Observable<Int> {
        segmentedControl.rx.selectedSegmentIndex.asObservable()
    }
}

// MARK: - UICollectionViewCompositionalLayout

private extension HomeView {
    func configureCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] section, _ in
            switch HomeViewModel.SectionType.allCases[section] {
            case .main:
                return self?.configureMainLayout()
            case .mostViewed:
                return self?.configureMostViewedLayout()
            case .recommend, .paramounts:
                return self?.configureImageAndTitleLayout()
            case .longLogo:
                return self?.configureLongLogoLayout()
            }
        }
    }
    
    func configureMainLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1), heightDimension: .absolute(Screen.height(530))
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        return section
    }
    
    func configureImageAndTitleLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(Screen.width(98)), heightDimension: .absolute(Screen.height(170))
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 40, trailing: 0)
        section.boundarySupplementaryItems = [configureHeaderView()]
        
        return section
    }
    
    func configureMostViewedLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(Screen.width(160)), heightDimension: .absolute(Screen.height(140))
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 40, trailing: 0)
        section.boundarySupplementaryItems = [configureHeaderView()]
        
        return section
    }
    
    func configureLongLogoLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(Screen.width(187)), heightDimension: .absolute(Screen.height(58))
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 40, trailing: 0)
        
        return section
    }
    
    func configureHeaderView() -> NSCollectionLayoutBoundarySupplementaryItem {
        let size = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1), heightDimension: .estimated(25)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: size,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        return header
    }
}

private extension HomeView {
    
    // MARK: - SetUI
    
    func setUI() {
        backgroundColor = .black
        
        homeCollectionView.do {
            $0.backgroundColor = .black
            $0.showsHorizontalScrollIndicator = false
            $0.showsVerticalScrollIndicator = false
            $0.contentInsetAdjustmentBehavior = .never
            $0.register(
                MainCell.self,
                forCellWithReuseIdentifier: MainCell.reuseIdentifier
            )
            $0.register(
                ImageAndTitleCell.self,
                forCellWithReuseIdentifier: ImageAndTitleCell.reuseIdentifier
            )
            $0.register(
                MostCell.self,
                forCellWithReuseIdentifier: MostCell.reuseIdentifier
            )
            $0.register(
                LongLogoCell.self,
                forCellWithReuseIdentifier: LongLogoCell.reuseIdentifier
            )
            $0.register(
                SectionHeaderView.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: SectionHeaderView.reuseIdentifier
            )
        }
        
        [realTimeView, tvProgramView, movieView, paramountView].forEach {
            $0.isHidden = true
        }
    }
    
    func setViewHierarchy() {
        addSubviews(
            topBackgroundView, segmentedControl, homeCollectionView, realTimeView,
            tvProgramView, movieView, paramountView
        )
        
        bringSubviewToFront(topBackgroundView)
        bringSubviewToFront(segmentedControl)
    }
    
    // MARK: - AutoLayout
    
    func setAutoLayout() {
        let safeArea = safeAreaLayoutGuide
        
        segmentedControl.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(safeArea)
            $0.height.equalTo(40)
        }
        
        topBackgroundView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(segmentedControl)
        }
        
        segmentViews.forEach { view in
            view.snp.makeConstraints {
                $0.top.horizontalEdges.equalToSuperview()
                $0.bottom.equalTo(safeArea)
            }
        }
    }
}
