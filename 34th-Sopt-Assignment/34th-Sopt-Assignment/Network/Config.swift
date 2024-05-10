//
//  Config.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 5/10/24.
//

import Foundation

enum Config {
    enum Keys {
        enum Plist {
            static let baseURL = "BASE_URL"
            static let boxOffice = "BoxOffice_API_KEY"
        }
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("info.plist cannot found.")
        }
        return dict
    }()
    
    private static let apiKeysDictionary: [String: String] = {
        guard let dict = Bundle.main.apiKeysDictionary as? [String: String] else {
            fatalError("APIKeys.plist cannot found.")
        }
        return dict
    }()
}

extension Config {
    static let baseURL: String = {
        guard let key = Config.infoDictionary[Keys.Plist.baseURL] as? String else {
            fatalError("Base URL is not set in plist for this configuration.")
        }
        return key
    }()
    
    static let boxOfficeAPIKey: String = {
        guard let key = Config.apiKeysDictionary[Keys.Plist.boxOffice] else {
            fatalError("APIKey is not set in plist for this configuration.")
        }
        return key
    }()
}
