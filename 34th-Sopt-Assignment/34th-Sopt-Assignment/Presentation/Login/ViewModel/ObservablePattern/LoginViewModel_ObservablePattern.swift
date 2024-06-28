//
//  LoginViewModel_ObservablePattern.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 6/29/24.
//

import Foundation

final class LoginViewModel_ObservablePattern {
    var isLoginEnabled = ObservablePattern<Bool>(false)
    var isSucceedToLogin = ObservablePattern<String>("")
    var errorMessage = ObservablePattern<AppError>(.unknown)
    
    func enableLogin(id: String?, pw: String?) {
        guard let id, !id.isEmpty,
              let pw, !pw.isEmpty
        else {
            isLoginEnabled.assign(false)
            return
        }
        isLoginEnabled.assign(true)
    }
    
    func checkInput(id: String?, pw: String?) {
        guard let id,
              checkFrom(input: id, regex: .id)
        else {
            errorMessage.assign(.login(error: .invalidID))
            return
        }
        
        guard let pw,
              checkFrom(input: pw, regex: .pw)
        else {
            errorMessage.assign(.login(error: .invalidPW))
            return
        }
        
        isSucceedToLogin.assign(id)
    }
}

extension LoginViewModel_ObservablePattern: RegexCheckable {}
