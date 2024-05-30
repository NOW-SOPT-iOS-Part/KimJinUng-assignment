//
//  HomeViewController.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 4/29/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class HomeViewController: UIViewController {
    
    // MARK: - Section
    
    enum Section {
        case main([Program])
        case recommend([Program])
        case mostViewed([Program])
        case paramounts([Program])
        case longLogo([Program])
    }
    
    // MARK: - UIComponent
    
    private let topBackgroundView = UIView(backgroundColor: .clear)
    private let segmentedControl = UnderlineSegmentedControl(
        items: ["홈", "실시간", "프로그램", "영화", "파라마운트+"]
    )
    private lazy var homeCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: configureCompositionalLayout()
    )
    private let realTimeView = UIView(backgroundColor: .gray4)
    private let tvProgramView = UIView(backgroundColor: .gray3)
    private let movieView = UIView(backgroundColor: .gray2)
    private let paramountView = UIView(backgroundColor: .gray1)
    
    // MARK: - Property
    
    private var segmentViews: [UIView] {
        [homeCollectionView, realTimeView, tvProgramView, movieView, paramountView]
    }
    private var sectionData: [Section] = []
    
    private let viewModel: HomeViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializer
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setNavigationBar()
        setViewHierarchy()
        setAutoLayout()
        setDelegate()
        
        bindViewModel()
        bindAction()
        
        viewModel.viewDidLoad()
    }
}

private extension HomeViewController {
    
    // MARK: - ViewModel Binding
    
    func bindViewModel() {
        viewModel.isViewDidLoad
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] data in
                self?.sectionData = data
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Action Binding
    
    func bindAction() {
        segmentedControl.rx.selectedSegmentIndex
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] index in
                guard let self else { return }
                for i in 0..<segmentViews.count {
                    segmentViews[i].isHidden = i != index
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Private Method

private extension HomeViewController {
    func moveToFind() {
        let boxOfficeService = DefaultNetworkService<BoxOfficeTargetType>()
        let findViewModel = DefaultFindViewModel(boxOfficeService: boxOfficeService)
        let findViewController = FindViewController(viewModel: findViewModel)
        navigationController?.pushViewController(findViewController, animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch sectionData[section] {
        case .main:
            return 1
        case .recommend(let data), .paramounts(let data), .mostViewed(let data), .longLogo(let data):
            return data.count
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch sectionData[indexPath.section] {
        case .main(let programs):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MainCell.reuseIdentifier,
                for: indexPath
            ) as? MainCell else { return UICollectionViewCell() }
            cell.bind(data: programs)
            return cell
            
        case .mostViewed(let data):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MostCell.reuseIdentifier,
                for: indexPath
            ) as? MostCell else { return UICollectionViewCell() }
            cell.bind(data: data[indexPath.row])
            return cell
            
        case .recommend(let data), .paramounts(let data):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ImageAndTitleCell.reuseIdentifier,
                for: indexPath
            ) as? ImageAndTitleCell else { return UICollectionViewCell() }
            cell.bind(data: data[indexPath.row])
            return cell
            
        case .longLogo(let data):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: LongLogoCell.reuseIdentifier,
                for: indexPath
            ) as? LongLogoCell else { return UICollectionViewCell() }
            cell.bind(image: data[indexPath.row].image)
            return cell
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: SectionHeaderView.reuseIdentifier,
            for: indexPath
        ) as? SectionHeaderView else { return UICollectionReusableView() }
        
        switch sectionData[indexPath.section] {
        case .mostViewed:
            headerView.bind(title: "인기 LIVE 채널")
        case .paramounts:
            headerView.bind(title: "1회 무료! 파라마운트+ 인기 시리즈")
        case .recommend:
            headerView.bind(title: "티빙에서 꼭 봐야하는 콘텐츠")
        case .main, .longLogo:
            break
        }
        return headerView
    }
}

// MARK: - UICollectionViewDelegate

extension HomeViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.bounds.minY
        navigationController?.setNavigationBarHidden(y <= 0 ? false : true, animated: false)
        topBackgroundView.backgroundColor = y <= 0 ? .clear : .black
    }
}

// MARK: - UICollectionViewCompositionalLayout

private extension HomeViewController {
    func configureCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { section, _ in
            switch self.sectionData[section] {
            case .main:
                return self.configureMainLayout()
            case .mostViewed:
                return self.configureMostViewedLayout()
            case .recommend, .paramounts:
                return self.configureImageAndTitleLayout()
            case .longLogo:
                return self.configureLongLogoLayout()
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

private extension HomeViewController {
    
    // MARK: - SetUI
    
    func setUI() {
        view.backgroundColor = .black
        
        homeCollectionView.do {
            $0.backgroundColor = .black
            $0.showsHorizontalScrollIndicator = false
            $0.showsVerticalScrollIndicator = false
            $0.contentInsetAdjustmentBehavior = .never
            $0.register(MainCell.self, forCellWithReuseIdentifier: MainCell.reuseIdentifier)
            $0.register(
                ImageAndTitleCell.self,
                forCellWithReuseIdentifier: ImageAndTitleCell.reuseIdentifier
            )
            $0.register(MostCell.self, forCellWithReuseIdentifier: MostCell.reuseIdentifier)
            $0.register(LongLogoCell.self, forCellWithReuseIdentifier: LongLogoCell.reuseIdentifier)
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
        
        let findButton = UIBarButtonItem(
            image: UIImage(systemName: "magnifyingglass")?.withTintColor(.white, renderingMode: .alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(findButtonTapped)
        )
        
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItems = [rightButton, findButton]
        
        navigationController?.hidesBarsOnSwipe = true
    }
    
    func setViewHierarchy() {
        view.addSubviews(
            topBackgroundView, segmentedControl, homeCollectionView, realTimeView,
            tvProgramView, movieView, paramountView
        )
        
        view.bringSubviewToFront(topBackgroundView)
        view.bringSubviewToFront(segmentedControl)
    }
    
    // MARK: - AutoLayout
    
    func setAutoLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
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
    
    // MARK: - Delegate
    
    func setDelegate() {
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
    }
    
    // MARK: - Action
    
    @objc
    private func findButtonTapped(_ sender: UIBarButtonItem) {
        moveToFind()
    }
}
