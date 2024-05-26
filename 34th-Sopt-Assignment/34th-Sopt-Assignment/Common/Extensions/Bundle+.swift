//
//  Bundle+.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 5/10/24.
//

import Foundation

extension Bundle {
    var apiKeysDictionary: NSDictionary? {
        guard let file = self.path(forResource: "APIKeys", ofType: "plist"),
              let resource = NSDictionary(contentsOf: URL(fileURLWithPath: file))
        else {
            return nil
        }
        return resource
    }
}
