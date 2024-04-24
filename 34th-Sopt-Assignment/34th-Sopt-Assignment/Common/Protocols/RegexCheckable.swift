//
//  InputCheckable.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 4/18/24.
//

import Foundation

protocol RegexCheckable {
    func checkFrom(input: String, regex: Regex) -> Bool
}

extension RegexCheckable {
    func checkFrom(input: String, regex: Regex) -> Bool {
        return input.range(of: regex.format, options: .regularExpression) != nil
    }
}
