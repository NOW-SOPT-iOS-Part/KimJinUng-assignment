//
//  SectionHeaderView.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 4/30/24.
//

import UIKit
import Then
import SnapKit

final class SectionHeaderView: UICollectionReusableView, ReuseIdentifiable {
    
    // MARK: - UIComponent
    
    private let titleLabel = UILabel()
    private let viewAllButton = UIButton()

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
    
    func bind(title: String) {
        titleLabel.text = title
    }
}

private extension SectionHeaderView {
    
    // MARK: - SetUI

    func setUI() {
        titleLabel.setText("", color: .white, font: .pretendard(.semiBold, size: 15))
        
        viewAllButton.do {
            $0.setTitle(
                title: "전체보기",
                titleColor: .gray2,
                font: .pretendard(.medium, size: 11)
            )
            $0.setImage(UIImage(systemName: "chevron.right"), for: .normal)
            $0.tintColor = .gray2
            $0.semanticContentAttribute = .forceRightToLeft
        }
    }
    
    func setViewHierarchy() {
        addSubviews(titleLabel, viewAllButton)
    }
    
    // MARK: - AutoLayout

    func setAutoLayout() {
        titleLabel.snp.makeConstraints {
            $0.bottom.leading.equalToSuperview()
        }
        
        viewAllButton.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-15)
            $0.height.equalTo(15)
        }
    }
}
