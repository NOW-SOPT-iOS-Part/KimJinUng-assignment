//
//  LoginView.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 6/17/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class LoginView: UIView {
    
    // MARK: - Component
    
    private let titleLabel = UILabel()
    private let idTextField = TvingTextField(placeholder: "아이디", type: .id)
    private let idTextFieldRightView = UIView()
    private let idClearButton = UIButton()
    private let pwTextField = TvingTextField(placeholder: "비밀번호", type: .pw)
    private let pwTextFieldRightView = UIView()
    private let pwClearButton = UIButton()
    private let pwShowButton = UIButton()
    private let loginButton = UIButton()
    private let findIDButton = UIButton()
    private let divider = UIView()
    private let findPWButton = UIButton()
    private let helpButton = UIButton()
    private let nicknameButton = UIButton()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setViewHierarchy()
        setAutoLayout()
        setDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        endEditing(true)
    }
    
    func toggleLoginButton(_ flag: Bool) {
        let borderWidth: CGFloat = flag ? 0 : 1
        let titleColor: UIColor = flag ? .white : .gray2
        let backgroundColor: UIColor = flag ? .tvingRed : .black
        
        loginButton.setTitleColor(titleColor, for: .normal)
        loginButton.backgroundColor = backgroundColor
        loginButton.layer.borderWidth = borderWidth
        loginButton.isEnabled = flag
    }
    
    func clearIDTextField() {
        idTextField.text = nil
        idTextField.insertText("")
    }
    
    func clearPWTextField() {
        pwTextField.text = nil
        pwTextField.insertText("")
    }
    
    func togglePasswordTextFieldVisibility() {
        pwTextField.isSecureTextEntry.toggle()
        pwShowButton.setImage(
            pwTextField.isSecureTextEntry ? .eyeSlash : .eye , for: .normal
        )
    }
}

extension LoginView {
    var idTextFieldDidChange: Observable<String?> { idTextField.rx.text.asObservable() }
    var pwTextFieldDidChange: Observable<String?> { pwTextField.rx.text.asObservable() }
    var loginButtonDidTap: Observable<Void> { loginButton.rx.tap.asObservable() }
    var idClearButtonDidTap: Observable<Void> { idClearButton.rx.tap.asObservable() }
    var pwClearButtonDidTap: Observable<Void> { pwClearButton.rx.tap.asObservable() }
    var pwShowButtonDidTap: Observable<Void> { pwShowButton.rx.tap.asObservable() }
    var nicknameButtonDidTap: Observable<Void> { nicknameButton.rx.tap.asObservable() }
}

// MARK: - UITextFieldDelegate

extension LoginView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 1
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0
    }
}

private extension LoginView {
    
    // MARK: - SetUI
    
    func setUI() {
        backgroundColor = .black
        
        titleLabel.do {
            $0.setText("TVING ID 로그인", color: .gray1, font: .pretendard(.medium, size: 23))
            $0.textAlignment = .center
        }
        
        idTextField.rightView = idTextFieldRightView
        
        idClearButton.setImage(UIImage(resource: .xCircle), for: .normal)
        
        pwTextField.rightView = pwTextFieldRightView
        
        pwShowButton.setImage(UIImage(resource: .eyeSlash), for: .normal)
        
        pwClearButton.setImage(UIImage(resource: .xCircle), for: .normal)
        
        loginButton.do {
            $0.setTitle(
                title: "로그인하기",
                titleColor: .gray2,
                font: .pretendard(.semiBold, size: 14)
            )
            $0.setLayer(borderWidth: 1)
            $0.isEnabled = false
            $0.backgroundColor = .black
        }
        
        findIDButton.setTitle(
            title: "아이디 찾기",
            titleColor: .gray2,
            font: .pretendard(.semiBold, size: 14)
        )
        
        divider.backgroundColor = .gray4
        
        findPWButton.setTitle(
            title: "비밀번호 찾기",
            titleColor: .gray2,
            font: .pretendard(.semiBold, size: 14)
        )
        
        helpButton.setTitle(
            title: "아직 계정이 없으신가요?",
            titleColor: .gray3,
            font: .pretendard(.semiBold, size: 14)
        )
        
        nicknameButton.do {
            $0.setTitle(
                title: "닉네임 만들러가기",
                titleColor: .gray2,
                font: .pretendard(.regular, size: 14)
            )
            $0.addUnderline()
        }
    }
    
    func setViewHierarchy() {
        addSubviews(
            titleLabel, idTextField, pwTextField, loginButton, findIDButton,
            divider, findPWButton, helpButton, nicknameButton
        )
        
        idTextFieldRightView.addSubview(idClearButton)
        pwTextFieldRightView.addSubviews(pwShowButton, pwClearButton)
    }
    
    // MARK: - AutoLayout
    
    func setAutoLayout() {
        let safeArea = safeAreaLayoutGuide
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(safeArea.snp.top).offset(50)
        }
        
        idTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.horizontalEdges.equalTo(safeArea).inset(20)
            $0.height.equalTo(Constants.UI.textFieldAndButtonHeight)
        }
        
        idTextFieldRightView.snp.makeConstraints {
            $0.width.equalTo(35)
            $0.height.equalTo(Constants.UI.textFieldAndButtonHeight)
        }
        
        idClearButton.snp.makeConstraints {
            $0.size.equalTo(20)
            $0.leading.centerY.equalTo(idTextFieldRightView)
        }
        
        pwTextField.snp.makeConstraints {
            $0.top.equalTo(idTextField.snp.bottom).offset(7)
            $0.horizontalEdges.height.equalTo(idTextField)
        }
        
        pwTextFieldRightView.snp.makeConstraints {
            $0.width.equalTo(70)
            $0.height.equalTo(Constants.UI.textFieldAndButtonHeight)
        }
        
        pwShowButton.snp.makeConstraints {
            $0.size.equalTo(20)
            $0.leading.centerY.equalTo(pwTextFieldRightView)
        }
        
        pwClearButton.snp.makeConstraints {
            $0.size.equalTo(20)
            $0.trailing.equalTo(pwTextFieldRightView.snp.trailing).offset(-20)
            $0.centerY.equalTo(pwTextFieldRightView)
        }
        
        loginButton.snp.makeConstraints {
            $0.top.equalTo(pwTextField.snp.bottom).offset(20)
            $0.horizontalEdges.height.equalTo(idTextField)
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
    
    // MARK: - Delegate
    
    func setDelegate() {
        idTextField.delegate = self
        pwTextField.delegate = self
    }
}
