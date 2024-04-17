//
//  UIColor+Extension.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 4/17/24.
//

import UIKit

extension UIColor {
    
    enum GrayHexScale {
        case scale_191919, scale_2E2E2E, scale_626262, scale_9C9C9C, scale_D6D6D6
    }
    
    static func grayFrom(hex: GrayHexScale) -> UIColor {
        switch hex {
        case .scale_191919:
            return .gray5
        case .scale_2E2E2E:
            return .gray4
        case .scale_626262:
            return .gray3
        case .scale_9C9C9C:
            return .gray2
        case .scale_D6D6D6:
            return .gray1
        }
    }
}
