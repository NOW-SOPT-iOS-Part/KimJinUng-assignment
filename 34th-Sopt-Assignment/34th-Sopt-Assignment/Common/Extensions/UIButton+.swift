//
//  UIButton+.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 4/16/24.
//

import UIKit

extension UIButton {
    func setTitle(
        title: String,
        titleColor: UIColor = .white,
        font: UIFont? = nil
    ) {
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        titleLabel?.font = font
    }
    
    func setLayer(
        borderWidth: CGFloat = 0,
        borderColor: UIColor = .gray4,
        cornerRadius: CGFloat = Constants.UI.cornerRadius
    ) {
        layer.borderColor = borderColor.cgColor
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
    }
    
    func addUnderline() {
        let attributedString = NSMutableAttributedString(string: self.titleLabel?.text ?? "")
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
        self.setAttributedTitle(attributedString, for: .normal)
    }
}
