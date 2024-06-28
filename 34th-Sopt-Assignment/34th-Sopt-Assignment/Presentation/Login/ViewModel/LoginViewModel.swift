//
//  LoginViewModel.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 5/26/24.
//

import RxSwift
import RxCocoa

final class LoginViewModel: ViewModelType {
    struct Input {
        let idTextFieldDidChange: Observable<String?>
        let passwordTextFieldDidChange: Observable<String?>
        let loginButtonDidTap: Observable<Void>
        let idClearButtonDidTap: Observable<Void>
        let pwClearButtonDidTap: Observable<Void>
        let pwShowButtonDidTap: Observable<Void>
        let nicknameButtonDidTap: Observable<Void>
    }
    
    struct Output {
        let isLoginEnabled: Driver<Bool>
        let isSucceedToLogin: Driver<Result<String, AppError>>
        let clearIdTextField: Driver<Void>
        let clearPasswordTextField: Driver<Void>
        let togglePasswordTextFieldVisibility: Driver<Void>
        let presentNickname: Driver<Void>
    }
    
    func transform(from input: Input, with disposeBag: DisposeBag) -> Output {
        let isLoginEnabled = Observable
            .combineLatest(input.idTextFieldDidChange, input.passwordTextFieldDidChange)
            .map { id, pw in
                guard let id, !id.isEmpty,
                      let pw, !pw.isEmpty
                else {
                    return false
                }
                return true
            }
            .asDriver(onErrorJustReturn: false)
        
        let isSucceedToLogin = input.loginButtonDidTap
            .withLatestFrom(
                Observable.combineLatest(
                    input.idTextFieldDidChange, input.passwordTextFieldDidChange
                )
            ).flatMap { [weak self] id, pw -> Observable<Result<String, AppError>> in
                guard let self,
                      let id,
                      let pw
                else {
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
            .asDriver(onErrorJustReturn: .failure(.unknown))
        
        let clearIdTextField = input.idClearButtonDidTap
            .asDriver(onErrorJustReturn: ())
        
        let clearPasswordTextField = input.pwClearButtonDidTap
            .asDriver(onErrorJustReturn: ())
        
        let togglePasswordTextFieldVisibility = input.pwShowButtonDidTap
            .asDriver(onErrorJustReturn: ())
        
        let presentNickname = input.nicknameButtonDidTap
            .asDriver(onErrorJustReturn: ())
        
        let output = Output(
            isLoginEnabled: isLoginEnabled,
            isSucceedToLogin: isSucceedToLogin,
            clearIdTextField: clearIdTextField,
            clearPasswordTextField: clearPasswordTextField,
            togglePasswordTextFieldVisibility: togglePasswordTextFieldVisibility,
            presentNickname: presentNickname
        )
        
        return output
    }
}

extension LoginViewModel: RegexCheckable {}
