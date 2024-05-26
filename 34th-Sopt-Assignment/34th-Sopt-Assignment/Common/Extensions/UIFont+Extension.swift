//
//  UIFont+Extension.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 4/15/24.
//

import UIKit

extension UIFont {
    enum CustomWeight {
        case thin, extraLight, light, regular, medium, semiBold, bold, extraBold, black
        
        var font: String {
            switch self {
            case .thin: "Pretendard-Thin"
            case .extraLight: "Pretendard-ExtraLight"
            case .light: "Pretendard-Light"
            case .regular: "Pretendard-Regular"
            case .medium: "Pretendard-Medium"
            case .semiBold: "Pretendard-SemiBold"
            case .bold: "Pretendard-Bold"
            case .extraBold: "Pretendard-ExtraBold"
            case .black: "Pretendard-Black"
            }
        }
    }
    
    static func pretendard(_ weight: UIFont.CustomWeight, size: CGFloat) -> UIFont? {
        return UIFont(name: weight.font, size: size)
    }
}
