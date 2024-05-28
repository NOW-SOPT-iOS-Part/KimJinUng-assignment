//
//  LoginViewModel.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 5/26/24.
//

import RxSwift
import RxRelay

final class DefaultLoginViewModel: LoginViewModel, RegexCheckable {
    
    // MARK: - Output
    
    private(set) var isLoginEnabled: Observable<Bool>?
    private(set) var isSucceedToLogin: Observable<Result<String, AppError>>?
    
    private let idTextFieldRelay = PublishRelay<String?>()
    private let passwordTextFieldRelay = PublishRelay<String?>()
    private let loginButtonRelay = PublishRelay<Void>()
    
    // MARK: - Initializer

    init() {
        setOutput()
    }
    
    // MARK: - Input

    func idTextFieldDidChange(_ text: String?) {
        idTextFieldRelay.accept(text)
    }
    
    func passwordTextFieldDidChange(_ text: String?) {
        passwordTextFieldRelay.accept(text)
    }
    
    func loginButtonDidTap() {
        loginButtonRelay.accept(())
    }
}

private extension DefaultLoginViewModel {
    func setOutput() {
        isLoginEnabled = Observable
            .combineLatest(idTextFieldRelay, passwordTextFieldRelay)
            .map { id, pw in
                guard let id, !id.isEmpty,
                      let pw, !pw.isEmpty else {
                    return false
                }
                return true
            }
        
        isSucceedToLogin = loginButtonRelay
            .withLatestFrom(Observable.combineLatest(idTextFieldRelay, passwordTextFieldRelay))
            .flatMap { id, pw -> Observable<Result<String, AppError>> in
                guard let id, let pw else {
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
