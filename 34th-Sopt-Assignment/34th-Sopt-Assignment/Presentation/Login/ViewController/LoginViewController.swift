//
//  LoginViewController.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 4/15/24.
//

import UIKit

import RxCocoa
import RxSwift

final class LoginViewController: UIViewController, AlertShowable {
    
    // MARK: - Property
    
    weak var coordinator: LoginCoordinator?
    
    private var nickname: String?
    
    private let viewModel: LoginViewModel
    private let disposeBag = DisposeBag()
    private let rootView = LoginView()
    
    // MARK: - Initializer
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
}

private extension LoginViewController {
    
    // MARK: - ViewModel Binding
    
    func bindViewModel() {
        let input = LoginViewModel.Input(
            idTextFieldDidChange: rootView.idTextFieldDidChange,
            passwordTextFieldDidChange: rootView.pwTextFieldDidChange,
            loginButtonDidTap: rootView.loginButtonDidTap,
            idClearButtonDidTap: rootView.idClearButtonDidTap,
            pwClearButtonDidTap: rootView.pwClearButtonDidTap,
            pwShowButtonDidTap: rootView.pwShowButtonDidTap,
            nicknameButtonDidTap: rootView.nicknameButtonDidTap
        )
        
        let output = viewModel.transform(from: input, with: disposeBag)
        
        output.isLoginEnabled
            .drive(with: self) { owner, flag in
                owner.rootView.toggleLoginButton(flag)
            }
            .disposed(by: disposeBag)
        
        output.isSucceedToLogin
            .drive(with: self) { owner, result in
                switch result {
                case .success(let id):
                    owner.coordinator?.pushToWelcome(id: id, nickname: owner.nickname)
                case .failure(let error):
                    owner.showAlert(title: error.title, message: error.message)
                }
            }
            .disposed(by: disposeBag)
        
        output.clearIdTextField
            .drive(with: self) { owner, _ in
                owner.rootView.clearIDTextField()
            }
            .disposed(by: disposeBag)
        
        output.clearPasswordTextField
            .drive(with: self) { owner, _ in
                owner.rootView.clearPWTextField()
            }
            .disposed(by: disposeBag)
        
        output.togglePasswordTextFieldVisibility
            .drive(with: self) { owner, _ in
                owner.rootView.togglePasswordTextFieldVisibility()
            }
            .disposed(by: disposeBag)
        
        output.presentNickname
            .drive(with: self) { owner, _ in
                owner.coordinator?.presentNickname(delegate: owner)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - MakeNicknameViewDelegate

extension LoginViewController: MakeNicknameViewDelegate {
    func configure(nickname: String) {
        self.nickname = nickname
    }
}
