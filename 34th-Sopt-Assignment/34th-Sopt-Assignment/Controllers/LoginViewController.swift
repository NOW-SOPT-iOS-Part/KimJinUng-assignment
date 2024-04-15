//
//  LoginViewController.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 4/15/24.
//

import Then
import UIKit
import SnapKit

final class LoginViewController: UIViewController {
    
    // MARK: - Component
    
    private let titleLabel = UILabel()
    
    private let idTextField = UITextField()
    
    private let pwTextField = UITextField()
    
    private let loginButton = UIButton()
    
    private let findIDButton = UIButton()
    
    private let divider = UIView()
    
    private let findPWButton = UIButton()
    
    private let helpButton = UIButton()
    
    private let nicknameButton = UIButton()
    
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
    private func loginButtonTapped(_ button: UIButton) {
        print(#function)
    }
}

extension LoginViewController {
    
    // MARK: - SetUI
    
    private func setUI() {
        view.backgroundColor = .basicBlack
        
        titleLabel.do {
            $0.text = "TVING ID 로그인"
            $0.textColor = .gray1
            $0.font = .pretendard(weight: .five, size: 23)
            $0.textAlignment = .center
        }
        
        idTextField.do {
            $0.backgroundColor = .gray4
            $0.layer.cornerRadius = 3
            $0.addPadding(left: 20)
            $0.setPlaceholder(
                placeholder: "아이디",
                fontColor: .gray2,
                font: .pretendard(weight: .six, size: 15)
            )
        }
        
        pwTextField.do {
            $0.backgroundColor = .gray4
            $0.layer.cornerRadius = 3
            $0.isSecureTextEntry = true
            $0.addPadding(left: 20)
            $0.setPlaceholder(
                placeholder: "비밀번호",
                fontColor: .gray2,
                font: .pretendard(weight: .six, size: 15)
            )
        }
        
        loginButton.do {
            $0.setTitle(
                title: "로그인하기",
                titleColor: .gray2,
                font: .pretendard(weight: .six, size: 14)
            )
            $0.backgroundColor = .black
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray4.cgColor
            $0.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        }
        
        findIDButton.do {
            $0.setTitle(
                title: "아이디 찾기",
                titleColor: .gray2,
                font: .pretendard(weight: .six, size: 14)
            )
        }
        
        divider.do {
            $0.backgroundColor = .gray4
        }
        
        findPWButton.do {
            $0.setTitle(
                title: "비밀번호 찾기",
                titleColor: .gray2,
                font: .pretendard(weight: .six, size: 14)
            )
        }
        
        helpButton.do {
            $0.setTitle(
                title: "아직 계정이 없으신가요?",
                titleColor: .gray3,
                font: .pretendard(weight: .six, size: 14)
            )
        }
        
        nicknameButton.do {
            $0.setTitle(
                title: "닉네임 만들러가기",
                titleColor: .gray2,
                font: .pretendard(weight: .four, size: 14)
            )
            $0.addUnderline()
        }
    }
    
    private func setViewHierarchy() {
        view.addSubviews(
            titleLabel, idTextField, pwTextField, loginButton, findIDButton,
            divider, findPWButton, helpButton, nicknameButton
        )
    }
    
    // MARK: - AutoLayout
    
    private func setAutoLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(safeArea.snp.top).offset(50)
        }
        
        idTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.leading.equalTo(safeArea.snp.leading).offset(20)
            $0.trailing.equalTo(safeArea.snp.trailing).offset(-20)
            $0.height.equalTo(52)
        }
        
        pwTextField.snp.makeConstraints {
            $0.top.equalTo(idTextField.snp.bottom).offset(7)
            $0.leading.trailing.height.equalTo(idTextField)
        }
        
        loginButton.snp.makeConstraints {
            $0.top.equalTo(pwTextField.snp.bottom).offset(20)
            $0.leading.trailing.height.equalTo(idTextField)
        }
        
        findIDButton.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(30)
            $0.leading.equalTo(safeArea.snp.leading).offset(85)
            $0.height.equalTo(22)
        }
        
        divider.snp.makeConstraints {
            $0.centerY.equalTo(findIDButton)
            $0.centerX.equalToSuperview().offset(-2)
            $0.width.equalTo(1)
            $0.height.equalTo(12)
        }
        
        findPWButton.snp.makeConstraints {
            $0.top.height.equalTo(findIDButton)
            $0.trailing.equalTo(safeArea.snp.trailing).offset(-85)
        }
        
        helpButton.snp.makeConstraints {
            $0.top.equalTo(findIDButton.snp.bottom).offset(30)
            $0.leading.equalTo(safeArea.snp.leading).offset(50)
            $0.height.equalTo(findIDButton)
        }
        
        nicknameButton.snp.makeConstraints {
            $0.top.height.equalTo(helpButton)
            $0.trailing.equalTo(safeArea.snp.trailing).offset(-50)
            $0.width.equalTo(128)
        }
    }
}
