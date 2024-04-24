//
//  Regex.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 4/18/24.
//

import Foundation

enum Regex {
    case id
    case pw
    case nickname
    
    var format: String {
        switch self {
        case .id:
            Constants.Regex.idRegex
        case .pw:
            Constants.Regex.pwRegex
        case .nickname:
            Constants.Regex.nicknameRegex
        }
    }
}
