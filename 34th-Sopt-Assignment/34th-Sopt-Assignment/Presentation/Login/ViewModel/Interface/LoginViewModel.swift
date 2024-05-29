//
//  LoginViewModel.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 5/29/24.
//

import RxSwift

protocol LoginViewModelInput {
    func idTextFieldDidChange(_ text: String?)
    func passwordTextFieldDidChange(_ text: String?)
    func loginButtonDidTap()
}

protocol LoginViewModelOutput {
    var isLoginEnabled: Observable<Bool> { get }
    var isSucceedToLogin: Observable<Result<String, AppError>> { get }
}

typealias LoginViewModel = LoginViewModelInput & LoginViewModelOutput