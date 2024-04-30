//
//  LongLogoCell.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 4/30/24.
//

import UIKit
import Then
import SnapKit

final class LongLogoCell: UICollectionViewCell, ReuseIdentifiable {
    
    // MARK: - UIComponent
    
    private let imageView = UIImageView()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setUI()
        setViewHierarchy()
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(image: UIImage) {
        imageView.image = image
    }
}

private extension LongLogoCell {
    
    // MARK: - SetUI
    
    func setUI() {
        imageView.do {
            $0.contentMode = .scaleAspectFill
        }
    }
    
    func setViewHierarchy() {
        addSubviews(imageView)
    }
    
    // MARK: - AutoLayout
    
    func setAutoLayout() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

