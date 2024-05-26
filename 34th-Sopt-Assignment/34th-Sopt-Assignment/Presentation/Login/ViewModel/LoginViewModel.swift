//
//  LoginViewModel.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 5/26/24.
//

import RxSwift
import RxRelay

final class LoginViewModel: ViewModelType, RegexCheckable {
    struct Input {
        let idTextFieldDidChange: Observable<String?>
        let passwordTextFieldDidChange: Observable<String?>
        let loginButtonDidTap: Observable<Void>
    }
    
    struct Output {
        let isLoginEnabled: Observable<Bool>
        let isSucceedToLogin: Observable<String>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let isLoginEnabled = Observable
            .combineLatest(
                input.idTextFieldDidChange, input.passwordTextFieldDidChange
            ).map { id, pw in
                guard let id, !id.isEmpty,
                      let pw, !pw.isEmpty
                else {
                    return false
                }
                return true
            }
        
        let isSucceedToLogin = input.loginButtonDidTap
            .withLatestFrom(Observable.combineLatest(
                input.idTextFieldDidChange, input.passwordTextFieldDidChange
            )).flatMap { [weak self] id, pw -> Observable<String> in
                guard let self,
                      let id,
                      let pw
                else {
                    return .error(AppError.unknown)
                }
                
                if !checkFrom(input: id, regex: .id) {
                    return .error(AppError.login(error: .invalidID))
                }
                
                if !checkFrom(input: pw, regex: .pw) {
                    return .error(AppError.login(error: .invalidPW))
                }
                
                return .just(id)
            }
        
        let output = Output(isLoginEnabled: isLoginEnabled, isSucceedToLogin: isSucceedToLogin)
        return output
    }
}
