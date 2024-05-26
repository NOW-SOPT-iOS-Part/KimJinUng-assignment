//
//  PopularCell.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 4/30/24.
//

import UIKit
import Then
import SnapKit

final class MostCell: UICollectionViewCell, ReuseIdentifiable {
    
    // MARK: - UIComponent
    
    private let imageView = UIImageView()
    private let rankingLabel = UILabel()
    private let vStackView = UIStackView(axis: .vertical)
    private let channelLabel = UILabel()
    private let titleLabel = UILabel()
    private let ratingLabel = UILabel()
    
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
        rankingLabel.text = "\(data.rank)"
        channelLabel.text = data.channel
        titleLabel.text = data.title
        ratingLabel.text = "\(data.rating)"
    }
}

private extension MostCell {
    
    // MARK: - SetUI
    
    func setUI() {
        imageView.layer.cornerRadius = 3
        
        rankingLabel.setText("", color: .white, font: .pretendard(.bold, size: 19))
        
        vStackView.do {
            $0.alignment = .leading
            $0.distribution = .fillEqually
            $0.spacing = 0
        }
        
        channelLabel.setText("", color: .white, font: .pretendard(.regular, size: 10))
        
        [titleLabel, ratingLabel].forEach {
            $0.setText("", color: .grayFrom(hex: .scale_9C9C9C), font: .pretendard(.regular, size: 10))
        }
    }
    
    func setViewHierarchy() {
        vStackView.addArrangedSubviews(channelLabel, titleLabel, ratingLabel)
        contentView.addSubviews(imageView, rankingLabel, vStackView)
    }
    
    // MARK: - AutoLayout
    
    func setAutoLayout() {
        imageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-60)
        }
        
        rankingLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(6)
        }
        
        vStackView.snp.makeConstraints {
            $0.top.equalTo(rankingLabel)
            $0.leading.equalTo(rankingLabel.snp.trailing).offset(3)
            $0.bottom.equalToSuperview()
        }
    }
}

