//
//  LoginViewController.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 4/15/24.
//

import Then
import UIKit
import SnapKit

final class LoginViewController: UIViewController, RegexCheckable, AlertShowable {
    
    // MARK: - Component
    
    private let titleLabel = UILabel()
    
    private let idTextField = UITextField()

    private let idTextFieldRightView = UIView()
    
    private let idClearButton = UIButton()
    
    private let pwTextField = UITextField()
    
    private let pwTextFieldRightView = UIView()
    
    private let pwClearButton = UIButton()
    
    private let pwShowButton = UIButton()
    
    private let loginButton = UIButton()
    
    private let findIDButton = UIButton()
    
    private let divider = UIView()
    
    private let findPWButton = UIButton()
    
    private let helpButton = UIButton()
    
    private let nicknameButton = UIButton()
    
    // MARK: - Property
    
    private var nickname: String?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setViewHierarchy()
        setAutoLayout()
        setDelegate()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func setDelegate() {
        idTextField.delegate = self
        pwTextField.delegate = self
    }
    
    // MARK: - Action
    
    @objc
    private func textFieldEditingChanged(_ sender: UITextField) {
        guard let idInput = idTextField.text, !idInput.isEmpty,
              let pwInput = pwTextField.text, !pwInput.isEmpty
        else {
            disableLoginButton()
            return
        }
        enableLoginButton()
    }
    
    private func disableLoginButton() {
        loginButton.do {
            $0.setLayer(borderColor: .gray4, borderWidth: 1)
            $0.setTitleColor(.gray2, for: .normal)
            $0.backgroundColor = .basicBlack
            $0.isEnabled = false
        }
    }
    
    private func enableLoginButton() {
        loginButton.do {
            $0.setTitleColor(.basicWhite, for: .normal)
            $0.backgroundColor = .brandRed
            $0.layer.borderWidth = 0
            $0.isEnabled = true
        }
    }
    
    @objc
    private func textFieldClearButtonTapped(_ sender: UIButton) {
        print(#function)
        switch sender.tag {
        case 0:
            idTextField.text = nil
            idTextField.insertText("")
        case 1:
            pwTextField.text = nil
            pwTextField.insertText("")
        default:
            break
        }
    }
    
    @objc
    private func pwShowButtonTapped(_ sender: UIButton) {
        print(#function)
        pwTextField.isSecureTextEntry.toggle()
        switch pwTextField.isSecureTextEntry {
        case true:
            sender.setImage(UIImage(named: Constants.Image.eye_slash), for: .normal)
        case false:
            sender.setImage(UIImage(named: Constants.Image.eye), for: .normal)
        }
    }
    
    @objc
    private func loginButtonTapped(_ sender: UIButton) {
        print(#function)
        do {
            let id = try checkID()
            try checkPW()
            moveToWelcome(with: id)
        } catch {
            let error = error as! AppError
            showAlert(title: "\(error)", message: "\(error.message)")
        }
    }
    
    private func moveToWelcome(with id: String) {
        guard let id = idTextField.text else { return }
        let viewController = WelcomeViewController(id: id, nickname: nickname)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func checkID() throws -> String {
        guard let input = idTextField.text,
              checkFrom(input: input, regex: .id)
        else {
            throw AppError.login(error: .invalidID)
        }
        return input
    }
    
    private func checkPW() throws {
        guard let input = pwTextField.text,
              checkFrom(input: input, regex: .pw)
        else {
            throw AppError.login(error: .invalidPW)
        }
    }
    
    @objc
    private func makeNicknameButtonTapped(_ sender: UIButton) {
        print(#function)
        let viewController = MakeNicknameViewController()
        viewController.delegate = self
        viewController.modalPresentationStyle = .formSheet
        if let sheet = viewController.sheetPresentationController {
            sheet.do {
                $0.detents = [.medium()]
                $0.prefersGrabberVisible = true
                $0.preferredCornerRadius = 24.0
            }
        }
        present(viewController, animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 1
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0
    }
}

// MARK: - MakeNicknameViewDelegate

extension LoginViewController: MakeNicknameViewDelegate {
    func configure(nickname: String) {
        self.nickname = nickname
    }
}

extension LoginViewController {
    
    // MARK: - SetUI
    
    private func setUI() {
        view.backgroundColor = .basicBlack
        
        titleLabel.do {
            $0.setText("TVING ID 로그인", color: .gray1, font: .pretendard(weight: .five, size: 23))
            $0.textAlignment = .center
        }
        
        idTextField.do {
            $0.setText(
                placeholder: "아이디",
                textColor: .basicWhite,
                backgroundColor: .gray4,
                placeholderColor: .gray2,
                font: .pretendard(weight: .six, size: 15)
            )
            $0.setAutoType()
            $0.setLayer(borderColor: .basicWhite)
            $0.addPadding(left: 20)
            $0.keyboardType = .emailAddress
            $0.rightView = idTextFieldRightView
            $0.rightViewMode = .whileEditing
            $0.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        }
        
        idClearButton.do {
            $0.setImage(UIImage(named: Constants.Image.x_circle), for: .normal)
            $0.addTarget(self, action: #selector(textFieldClearButtonTapped), for: .touchUpInside)
            $0.tag = 0
        }
        
        pwTextField.do {
            $0.setText(
                placeholder: "비밀번호",
                textColor: .basicWhite,
                backgroundColor: .gray4,
                placeholderColor: .gray2,
                font: .pretendard(weight: .six, size: 15)
            )
            $0.setAutoType()
            $0.setLayer(borderColor: .basicWhite)
            $0.addPadding(left: 20)
            $0.isSecureTextEntry = true
            $0.rightView = pwTextFieldRightView
            $0.rightViewMode = .whileEditing
            $0.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        }
        
        pwShowButton.do {
            $0.setImage(UIImage(named: Constants.Image.eye_slash), for: .normal)
            $0.addTarget(self, action: #selector(pwShowButtonTapped), for: .touchUpInside)
        }
        
        pwClearButton.do {
            $0.setImage(UIImage(named: Constants.Image.x_circle), for: .normal)
            $0.addTarget(self, action: #selector(textFieldClearButtonTapped), for: .touchUpInside)
            $0.tag = 1
        }
        
        loginButton.do {
            $0.setTitle(
                title: "로그인하기",
                titleColor: .gray2,
                font: .pretendard(weight: .six, size: 14)
            )
            $0.setLayer(borderColor: .gray4, borderWidth: 1)
            $0.isEnabled = false
            $0.backgroundColor = .black
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
            $0.addTarget(self, action: #selector(makeNicknameButtonTapped), for: .touchUpInside)
        }
    }
    
    private func setViewHierarchy() {
        view.addSubviews(
            titleLabel, idTextField, pwTextField, loginButton, findIDButton,
            divider, findPWButton, helpButton, nicknameButton
        )
        
        idTextFieldRightView.addSubview(idClearButton)
        pwTextFieldRightView.addSubviews(pwShowButton, pwClearButton)
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
            $0.height.equalTo(Constants.UI.textFieldAndButtonHeight)
        }
        
        idTextFieldRightView.snp.makeConstraints {
            $0.width.equalTo(35)
            $0.height.equalTo(Constants.UI.textFieldAndButtonHeight)
        }
        
        idClearButton.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.leading.centerY.equalTo(idTextFieldRightView)
        }
        
        pwTextField.snp.makeConstraints {
            $0.top.equalTo(idTextField.snp.bottom).offset(7)
            $0.leading.trailing.height.equalTo(idTextField)
        }
        
        pwTextFieldRightView.snp.makeConstraints {
            $0.width.equalTo(70)
            $0.height.equalTo(Constants.UI.textFieldAndButtonHeight)
        }
        
        pwShowButton.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.leading.centerY.equalTo(pwTextFieldRightView)
        }
        
        pwClearButton.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.trailing.equalTo(pwTextFieldRightView.snp.trailing).offset(-20)
            $0.centerY.equalTo(pwTextFieldRightView)
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
