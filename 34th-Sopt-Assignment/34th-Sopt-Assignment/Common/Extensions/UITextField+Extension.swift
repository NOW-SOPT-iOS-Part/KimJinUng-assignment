//
//  UITextField+Extension.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 4/15/24.
//

import UIKit

extension UITextField {
    
    func addPadding(left: CGFloat? = nil, right: CGFloat? = nil) {
        if let left {
            leftView = UIView(frame: CGRect(x: 0, y: 0, width: left, height: 0))
            leftViewMode = .always
        }
        if let right {
            rightView = UIView(frame: CGRect(x: 0, y: 0, width: right, height: 0))
            rightViewMode = .always
        }
    }
    
    func setTextField(forBackgroundColor: UIColor, forBorderColor: UIColor, forBorderWidth: CGFloat, forCornerRadius: CGFloat? = nil) {
        clipsToBounds = true
        layer.borderColor = forBorderColor.cgColor
        layer.borderWidth = forBorderWidth
        backgroundColor = forBackgroundColor
        
        if let cornerRadius = forCornerRadius {
            layer.cornerRadius = cornerRadius
        }  else {
            layer.cornerRadius = 0
        }
    }
    
    func setPlaceholder(placeholder: String, fontColor: UIColor?, font: UIFont?) {
        attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: fontColor!, .font: font!]
        )
    }
}
