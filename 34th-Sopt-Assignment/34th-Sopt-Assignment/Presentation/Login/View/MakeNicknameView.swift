//
//  MakeNicknameView.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 6/17/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class MakeNicknameView: UIView {
    
    // MARK: - Component
    
    private let titleLabel = UILabel()
    private let nicknameTextField = TvingTextField(placeholder: "닉네임", type: .nickname)
    private let saveButton = UIButton()
    
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
    
    func toggleSaveButton(_ flag: Bool) {
        let titleColor: UIColor = flag ? .white : .gray2
        let backgroundColor: UIColor = flag ? .tvingRed : .black
        let borderWidth: CGFloat = flag ? 0 : 1
        
        saveButton.setTitleColor(titleColor, for: .normal)
        saveButton.backgroundColor = backgroundColor
        saveButton.layer.borderWidth = borderWidth
        saveButton.isEnabled = flag
    }
}

extension MakeNicknameView {
    var nicknameTextFieldDidChange: Observable<String?> { nicknameTextField.rx.text.asObservable() }
    var saveButtonDidTap: Observable<Void> { saveButton.rx.tap.asObservable() }
}

private extension MakeNicknameView {
    
    // MARK: - SetUI
    
    func setUI() {
        backgroundColor = .systemBackground
        
        titleLabel.setText(
            "닉네임을 입력해주세요",
            color: .black,
            font: .pretendard(.medium, size: 23)
        )
        
        saveButton.do {
            $0.setTitle(
                title: "저장하기",
                titleColor: .gray2,
                font: .pretendard(.semiBold, size: 14)
            )
            $0.setLayer(borderWidth: 1, cornerRadius: 12)
            $0.isEnabled = false
            $0.backgroundColor = .black
        }
    }
    
    func setViewHierarchy() {
        addSubviews(titleLabel, nicknameTextField, saveButton)
    }
    
    // MARK: - AutoLayout
    
    func setAutoLayout() {
        let safeArea = safeAreaLayoutGuide
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.leading.equalToSuperview().offset(20)
        }
        
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.equalTo(titleLabel)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(Constants.UI.textFieldAndButtonHeight)
        }
        
        saveButton.snp.makeConstraints {
            $0.bottom.equalTo(safeArea.snp.bottom).offset(-10)
            $0.horizontalEdges.height.equalTo(nicknameTextField)
        }
    }
}
