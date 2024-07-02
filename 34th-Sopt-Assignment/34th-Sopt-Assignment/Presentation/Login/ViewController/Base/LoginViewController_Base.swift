//
//  LoginViewController_Base.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 7/3/24.
//

import UIKit

final class LoginViewController_Base: BaseViewController, AlertShowable {
    
    
    // MARK: - Property
    
    weak var coordinator: LoginCoordinator?
    
    private var nickname: String?
    
    private let viewModel: LoginViewModel_ObservablePattern
    private let rootView = LoginView_Base()
    
    
    // MARK: - Initializer
    
    init(viewModel: LoginViewModel_ObservablePattern) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func setupAction() {
        rootView.idTextField.addTarget(
            self,
            action: #selector(textFieldDidChange),
            for: .editingChanged
        )
        rootView.pwTextField.addTarget(
            self,
            action: #selector(textFieldDidChange),
            for: .editingChanged
        )
        rootView.loginButton.addTarget(
            self,
            action: #selector(loginButtonDidTap),
            for: .touchUpInside
        )
        rootView.idClearButton.addTarget(
            self,
            action: #selector(clearButtonDidTap(_:)),
            for: .touchUpInside
        )
        rootView.pwClearButton.addTarget(
            self,
            action: #selector(clearButtonDidTap(_:)),
            for: .touchUpInside
        )
        rootView.pwShowButton.addTarget(
            self,
            action: #selector(pwShowButtonDidTap(_:)),
            for: .touchUpInside
        )
        rootView.nicknameButton.addTarget(
            self,
            action: #selector(nicknameButtonDidTap),
            for: .touchUpInside
        )
    }
    
    override func setupDelegate() {
        rootView.idTextField.delegate = self
        rootView.pwTextField.delegate = self
    }
}


// MARK: - MakeNicknameViewDelegate

extension LoginViewController_Base: MakeNicknameViewDelegate {
    func configure(nickname: String) {
        self.nickname = nickname
    }
}


// MARK: - @objc Method

private extension LoginViewController_Base {
    @objc func textFieldDidChange() {
        viewModel.enableLogin(id: rootView.idTextField.text, pw: rootView.pwTextField.text)
    }
    
    @objc func loginButtonDidTap() {
        viewModel.checkInput(id: rootView.idTextField.text, pw: rootView.pwTextField.text)
    }
    
    @objc func clearButtonDidTap(_ sender: UIButton) {
        if sender == rootView.idClearButton {
            rootView.idTextField.text = nil
            rootView.idTextField.insertText("")
            return
        }
        
        if sender == rootView.pwClearButton {
            rootView.pwTextField.text = nil
            rootView.pwTextField.insertText("")
            return
        }
    }
    
    @objc func pwShowButtonDidTap(_ sender: UIButton) {
        rootView.pwTextField.isSecureTextEntry.toggle()
        sender.setImage(
            rootView.pwTextField.isSecureTextEntry ? .eyeSlash : .eye , for: .normal
        )
    }
    
    @objc func nicknameButtonDidTap() {
        coordinator?.presentNickname(delegate: self)
    }
}


// MARK: - UITextFieldDelegate

extension LoginViewController_Base: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 1
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0
    }
}

private extension LoginViewController_Base {
    func bindViewModel() {
        viewModel.isLoginEnabled
            .bind(with: self) { owner, flag in
                owner.toggleLoginButton(flag)
            }
        
        viewModel.isSucceedToLogin
            .bind(with: self) { owner, id in
                owner.coordinator?.pushToWelcome(id: id, nickname: owner.nickname)
            }
        
        viewModel.errorMessage
            .bind(with: self) { owner, error in
                owner.showAlert(title: error.title, message: error.message)
            }
    }
    
    func toggleLoginButton(_ flag: Bool) {
        let loginButton = rootView.loginButton
        let borderWidth: CGFloat = flag ? 0 : 1
        let titleColor: UIColor = flag ? .white : .gray2
        let backgroundColor: UIColor = flag ? .tvingRed : .black
        
        loginButton.setTitleColor(titleColor, for: .normal)
        loginButton.backgroundColor = backgroundColor
        loginButton.layer.borderWidth = borderWidth
        loginButton.isEnabled = flag
    }
}
