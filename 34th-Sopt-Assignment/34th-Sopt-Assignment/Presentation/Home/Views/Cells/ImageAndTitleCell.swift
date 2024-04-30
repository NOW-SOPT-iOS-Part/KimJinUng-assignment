//
//  ImageAndTitleCell.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 4/30/24.
//

import UIKit
import Then
import SnapKit

final class ImageAndTitleCell: UICollectionViewCell, ReuseIdentifiable {
    
    // MARK: - UIComponent
    
    private let imageView = UIImageView()
    
    private let titleLabel = UILabel()    
    
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
    
    func bind(data: Program) {
        imageView.image = data.image
        titleLabel.text = data.title
    }
}

private extension ImageAndTitleCell {
    
    // MARK: - SetUI
    
    func setUI() {
        imageView.do {
            $0.layer.cornerRadius = 3
        }
        titleLabel.do {
            $0.setText("", color: .grayFrom(hex: .scale_9C9C9C), font: .pretendard(weight: .five, size: 10))
        }
    }
    
    func setViewHierarchy() {
        addSubviews(imageView, titleLabel)
    }
    
    // MARK: - AutoLayout
    
    func setAutoLayout() {
        imageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-20)
        }
        titleLabel.snp.makeConstraints {
            $0.bottom.leading.equalToSuperview()
        }
    }
}

