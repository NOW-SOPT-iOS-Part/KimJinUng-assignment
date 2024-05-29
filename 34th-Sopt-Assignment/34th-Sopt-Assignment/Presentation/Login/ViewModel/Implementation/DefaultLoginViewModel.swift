//
//  DefaultLoginViewModel.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 5/26/24.
//

import RxSwift
import RxRelay

final class DefaultLoginViewModel: LoginViewModel {
    
    // MARK: - Output
    
    private(set) lazy var isLoginEnabled: Observable<Bool> = setIsLoginEnabled()
    private(set) lazy var isSucceedToLogin: Observable<Result<String, AppError>> = setIsSucceedToLogin()
    
    // MARK: - Input Relay

    private let idTextFieldDidChangeRelay = PublishRelay<String?>()
    private let passwordTextFieldDidChangeRelay = PublishRelay<String?>()
    private let loginButtonDidTapRelay = PublishRelay<Void>()
    
    // MARK: - Input

    func idTextFieldDidChange(_ text: String?) {
        idTextFieldDidChangeRelay.accept(text)
    }
    
    func passwordTextFieldDidChange(_ text: String?) {
        passwordTextFieldDidChangeRelay.accept(text)
    }
    
    func loginButtonDidTap() {
        loginButtonDidTapRelay.accept(())
    }
}

extension DefaultLoginViewModel: RegexCheckable {
    private func setIsLoginEnabled() -> Observable<Bool> {
        return Observable
            .combineLatest(idTextFieldDidChangeRelay, passwordTextFieldDidChangeRelay)
            .map { id, pw in
                guard let id, !id.isEmpty,
                      let pw, !pw.isEmpty else {
                    return false
                }
                return true
            }
    }
    
    private func setIsSucceedToLogin() -> Observable<Result<String, AppError>> {
        loginButtonDidTapRelay
            .withLatestFrom(Observable.combineLatest(idTextFieldDidChangeRelay, passwordTextFieldDidChangeRelay))
            .flatMap { [weak self] id, pw -> Observable<Result<String, AppError>> in
                guard let self, let id, let pw else {
                    return .just(.failure(.unknown))
                }
                
                if !self.checkFrom(input: id, regex: .id) {
                    return .just(.failure(.login(error: .invalidID)))
                }
                
                if !self.checkFrom(input: pw, regex: .pw) {
                    return .just(.failure(.login(error: .invalidPW)))
                }
                
                return .just(.success(id))
            }
    }
}
