//
//  UIFont+Extension.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 4/15/24.
//

import UIKit

extension UIFont {
    
    enum CustomWeight {
        case one, two, three, four, five, six, seven, eight, nine
        
        var font: String {
            switch self {
            case .one: "Pretendard-Thin"
            case .two: "Pretendard-ExtraLight"
            case .three: "Pretendard-Light"
            case .four: "Pretendard-Regular"
            case .five: "Pretendard-Medium"
            case .six: "Pretendard-SemiBold"
            case .seven: "Pretendard-Bold"
            case .eight: "Pretendard-ExtraBold"
            case .nine: "Pretendard-Black"
            }
        }
    }
    
    static func pretendard(weight: UIFont.CustomWeight, size: CGFloat) -> UIFont? {
        return UIFont(name: weight.font, size: size)
    }
}
