//
//  FindViewController.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 5/10/24.
//

import UIKit

import Then
import SnapKit

final class FindViewController: UIViewController {
    
    // MARK: - UIComponent
    
    private let backButton = UIButton()
    
    private let findTextField = TvingTextField(placeholder: "내용을 입력해주세요.")
    
    private let titleLabel = UILabel()
    
    // MARK: - Property
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setViewHierarchy()
        setAutoLayout()
    }
    
    // MARK: - Action
    
    @objc
    private func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

private extension FindViewController {
    
    // MARK: - SetUI
    
    func setUI() {
        view.backgroundColor = .black
        navigationItem.hidesBackButton = true
        
        backButton.do {
            $0.setImage(UIImage(resource: .btnBefore), for: .normal)
            $0.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        }
        
        titleLabel.do {
            $0.setText("일일 박스오피스 순위", color: .white, font: .pretendard(weight: .six, size: 15))
        }
    }
    
    func setViewHierarchy() {
        view.addSubviews(backButton, findTextField, titleLabel)
    }
    
    // MARK: - AutoLayout
    
    func setAutoLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
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
    }
}
