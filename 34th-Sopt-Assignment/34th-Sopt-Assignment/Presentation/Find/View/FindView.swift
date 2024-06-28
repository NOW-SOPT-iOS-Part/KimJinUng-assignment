//
//  FindView.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 6/28/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class FindView: UIView {
    
    // MARK: - UIComponent
    
    let boxOfficeListView = UITableView()
    
    private let backButton = UIButton()
    private let findTextField = TvingTextField(placeholder: "내용을 입력해주세요.")
    private let titleLabel = UILabel()
    
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
}

extension FindView {
    var backButtonDidTap: Observable<Void> { backButton.rx.tap.asObservable() }
}

// MARK: - UITableViewDelegate

extension FindView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

private extension FindView {
    
    // MARK: - SetUI
    
    func setUI() {
        backgroundColor = .black
        
        backButton.setImage(UIImage(resource: .btnBefore), for: .normal)
        
        titleLabel.setText(
            "일일 박스오피스 순위",
            color: .white,
            font: .pretendard(.semiBold, size: 15)
        )
        
        boxOfficeListView.do {
            $0.backgroundColor = .black
            $0.register(
                BoxOfficeCell.self,
                forCellReuseIdentifier: BoxOfficeCell.reuseIdentifier
            )
        }
    }
    
    func setViewHierarchy() {
        addSubviews(backButton, findTextField, titleLabel, boxOfficeListView)
    }
    
    // MARK: - AutoLayout
    
    func setAutoLayout() {
        let safeArea = safeAreaLayoutGuide
        
        backButton.snp.makeConstraints {
            $0.top.equalTo(safeArea)
            $0.leading.equalTo(safeArea).offset(20)
            $0.size.equalTo(20)
        }
        
        findTextField.snp.makeConstraints {
            $0.centerY.equalTo(backButton)
            $0.leading.equalTo(backButton.snp.trailing).offset(10)
            $0.trailing.equalTo(safeArea).offset(-20)
            $0.height.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(40)
            $0.leading.equalTo(backButton)
        }
        
        boxOfficeListView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(safeArea)
        }
    }
    
    // MARK: - Delegate

    func setDelegate() {
        boxOfficeListView.delegate = self
    }
}
