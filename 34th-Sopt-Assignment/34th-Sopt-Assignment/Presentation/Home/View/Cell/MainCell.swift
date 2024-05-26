//
//  MainCell.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 4/30/24.
//

import UIKit
import Then
import SnapKit

final class MainCell: UICollectionViewCell, ReuseIdentifiable {
    
    // MARK: - UIComponent
    
    private lazy var collectionView = UICollectionView(
        frame: .zero, 
        collectionViewLayout: configureCollectionViewFlowLayout()
    )
    private let pageControl = UIPageControl()
    
    // MARK: - Property
    
    private var data: [Program]?

    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setUI()
        setViewHierarchy()
        setAutoLayout()
        setDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(data: [Program]) {
        self.data = data
        pageControl.numberOfPages = data.count
    }
    
    private func configureCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = .init(width: UIScreen.main.bounds.width, height: Screen.height(498))
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return layout
    }
}

// MARK: - UICollectionViewDataSource

extension MainCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let data else { return 0 }
        return data.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let data = data,
              let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: InnerCell.reuseIdentifier,
                for: indexPath
        ) as? InnerCell 
        else {
            return UICollectionViewCell()
        }
        cell.bind(image: data[indexPath.row].image)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension MainCell: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        let currentPage = Int((scrollView.contentOffset.x + width / 2) / width)
        pageControl.currentPage = currentPage
    }
}

private extension MainCell {
    final class InnerCell: UICollectionViewCell, ReuseIdentifiable {
        
        // MARK: - UIComponent
        
        private let imageView = UIImageView().then {
            $0.contentMode = .scaleToFill
        }
        
        // MARK: - Initializer
        
        override init(frame: CGRect) {
            super.init(frame: .zero)
            
            contentView.addSubviews(imageView)
            
            imageView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func prepareForReuse() {
            super.prepareForReuse()
            imageView.image = nil
        }
        
        func bind(image: UIImage) {
            imageView.image = image
        }
    }
}

private extension MainCell {
    
    // MARK: - SetUI
    
    func setUI() {
        collectionView.do {
            $0.backgroundColor = .black
            $0.isPagingEnabled = true
            $0.showsHorizontalScrollIndicator = false
            $0.register(InnerCell.self, forCellWithReuseIdentifier: InnerCell.reuseIdentifier)
        }
        
        pageControl.do {
            $0.transform = .init(scaleX: 0.7, y: 0.7)
            $0.currentPageIndicatorTintColor = .white
            $0.pageIndicatorTintColor = .gray3
            $0.backgroundColor = .clear
        }
    }
    
    func setViewHierarchy() {
        contentView.addSubviews(collectionView, pageControl)
    }
    
    // MARK: - AutoLayout
    
    func setAutoLayout() {
        collectionView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(Screen.height(498))
        }
        
        pageControl.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(-30)
            $0.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Delegate
    
    private func setDelegate() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}
