//
//  UILabel+Extension.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 4/18/24.
//

import UIKit

extension UILabel {
    func setText(_ text: String, color: UIColor, font: UIFont?) {
        self.text = text
        self.textColor = color
        self.font = font
    }
}
