//
//  BoxOfficeCell.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 5/10/24.
//

import UIKit

import Then
import SnapKit

final class BoxOfficeCell: UITableViewCell, ReuseIdentifiable {
    
    // MARK: - UIComponent
    
    private let rankLabel = UILabel()
    
    private let movieTitleLabel = UILabel()
    
    private let numberLabel = UILabel()
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
        setViewHierarchy()
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(rank: String, title: String, number: String) {
        rankLabel.text = rank
        movieTitleLabel.text = title
        numberLabel.text = "\(number)명"
    }
}

private extension BoxOfficeCell {
    
    // MARK: - SetUI
    
    func setUI() {
        contentView.backgroundColor = .black
        
        rankLabel.setText("", color: .white, font: .pretendard(weight: .seven, size: 15))
        
        [movieTitleLabel, numberLabel].forEach {
            $0.setText("", color: .white, font: .pretendard(weight: .six, size: 13))
        }
    }
    
    func setViewHierarchy() {
        contentView.addSubviews(rankLabel, movieTitleLabel, numberLabel)
    }
    
    // MARK: - AutoLayout
    
    func setAutoLayout() {
        rankLabel.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
        }
        
        movieTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(rankLabel.snp.trailing).offset(20)
        }
        
        numberLabel.snp.makeConstraints {
            $0.trailing.centerY.equalToSuperview()
        }
    }
}

