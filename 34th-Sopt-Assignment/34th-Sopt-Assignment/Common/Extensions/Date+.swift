//
//  Date+.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 5/29/24.
//

import Foundation

extension Date {
    func toString(with format: DateFormat) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.format
        let formattedString = dateFormatter.string(from: self)
        return formattedString
    }
}

extension Date {
    enum DateFormat {
        case yyyyMMdd
        
        var format: String {
            switch self {
            case .yyyyMMdd: "yyyyMMdd"
            }
        }
    }
}
