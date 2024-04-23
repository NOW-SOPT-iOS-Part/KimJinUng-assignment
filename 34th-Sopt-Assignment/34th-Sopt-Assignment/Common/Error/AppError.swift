//
//  AppError.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 4/18/24.
//

import Foundation

enum AppError: Error, CustomStringConvertible {
    case login(error: LoginError)
    case nickname
    
    var description: String {
        switch self {
        case .login(let error):
            switch error {
            case .invalidID:
                "아이디 에러"
            case .invalidPW:
                "비밀번호 에러"
            }
        case .nickname:
            "닉네임 에러"
        }
    }
    
    var message: String {
        switch self {
        case .login(let error):
            error.description
        case .nickname:
            """
            올바른 닉네임 형식이 아닙니다.
            1~10자 이내 한글만 사용해 주세요.
            """
        }
    }
}

// MARK: - Error Case

extension AppError {
    enum LoginError: CustomStringConvertible {
        case invalidID, invalidPW
        
        var description: String {
            switch self {
            case .invalidID:
                "올바른 이메일 형식이 아닙니다."
            case .invalidPW:
                """
                올바른 비밀번호 형식이 아닙니다.
                8~10자 이내 영어, 특수기호만 사용해 주세요.
                """
            }
        }
    }
}
