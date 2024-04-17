//
//  Constants.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 4/17/24.
//

import Foundation

struct Constants {}

// MARK: - UI

extension Constants {
    struct UI {
        static let cornerRadius: CGFloat = 3
        static let textFieldAndButtonHeight = 52
    }
}

// MARK: - Regex

extension Constants {
    struct Regex {
        static let idRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        static let pwRegex = "[A-Za-z0-9!_@$%^&+=]{8,20}"
        static let nicknameRegex = "^[가-힣]{1,10}$"
    }
}

// MARK: - Image

extension Constants {
    struct Image {
        static let eye_slash = "eye_slash"
        static let eye = "eye"
        static let logo = "logo"
        static let x_circle = "x_circle"
    }
}
