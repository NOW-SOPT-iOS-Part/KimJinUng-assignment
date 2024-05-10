//
//  Bundle+Extension.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 5/10/24.
//

import Foundation

extension Bundle {
    enum Constants {
        static let filename = "APIKeys"
        static let filetype = "plist"
        static let boxOfficeKey = "BoxOffice_API_KEY"
    }
    
    var boxOfficeAPIKey: String? {
        guard let file = self.path(forResource: Constants.filename, ofType: Constants.filetype),
              let resource = NSDictionary(contentsOf: URL(fileURLWithPath: file)),
              let key = resource[Constants.boxOfficeKey] as? String
        else {
            return nil
        }
        return key
    }
}
