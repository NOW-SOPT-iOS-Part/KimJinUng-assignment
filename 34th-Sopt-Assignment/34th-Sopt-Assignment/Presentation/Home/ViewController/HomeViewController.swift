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
    
    // MARK: - Property
    
    weak var coordinator: HomeCoordinator?
    
    private let viewModel: HomeViewModel
    private let disposeBag = DisposeBag()
    private let rootView = HomeView()
    
    // MARK: - Initializer
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setDelegate()
        
        bindViewModel()
    }
}

private extension HomeViewController {
    
    // MARK: - ViewModel Binding
    
    func bindViewModel() {
        let input = HomeViewModel.Input(
            viewDidLoad: .just(()),
            selectedSegmentIndexChanged: rootView.selectedSegmentIndexChanged
        )
        
        let output = viewModel.transform(from: input, with: disposeBag)
        
        output.sections
            .drive(with: self) { owner, data in
                owner.rootView.homeCollectionView.reloadData()
            }
            .dispose()
        
        output.showSelectedSegmentView
            .drive(with: self) { owner, index in
                owner.rootView.updateSegmentView(index)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sections.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        let section = viewModel.sections[section]
        switch section.type {
        case .main:
            return 1
        case .recommend, .paramounts, .mostViewed, .longLogo:
            return section.items.count
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let section = viewModel.sections[indexPath.section]
        switch section.type {
        case .main:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MainCell.reuseIdentifier,
                for: indexPath
            ) as? MainCell else { 
                return UICollectionViewCell()
            }
            cell.bind(data: section.items)
            return cell
            
        case .mostViewed:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MostCell.reuseIdentifier,
                for: indexPath
            ) as? MostCell else { 
                return UICollectionViewCell()
            }
            cell.bind(data: section.items[indexPath.row])
            return cell
            
        case .recommend, .paramounts:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ImageAndTitleCell.reuseIdentifier,
                for: indexPath
            ) as? ImageAndTitleCell else {
                return UICollectionViewCell()
            }
            cell.bind(data: section.items[indexPath.row])
            return cell
            
        case .longLogo:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: LongLogoCell.reuseIdentifier,
                for: indexPath
            ) as? LongLogoCell else { 
                return UICollectionViewCell()
            }
            cell.bind(image: section.items[indexPath.row].image)
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
        ) as? SectionHeaderView else {
            return UICollectionReusableView()
        }
        switch HomeViewModel.SectionType.allCases[indexPath.section] {
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
        rootView.updateTopBackgroundColor(y <= 0)
    }
}

private extension HomeViewController {
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
    
    // MARK: - Delegate
    
    func setDelegate() {
        rootView.homeCollectionView.delegate = self
        rootView.homeCollectionView.dataSource = self
    }
    
    // MARK: - Action
    
    @objc
    private func findButtonTapped(_ sender: UIBarButtonItem) {
        coordinator?.pushToFind()
    }
}
