//
//  BoxOfficeTargetType.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 5/10/24.
//

import Foundation

import Moya

enum BoxOfficeTargetType {
    case dailyBoxOffice(date: String)
}

extension BoxOfficeTargetType: TargetType {
    var baseURL: URL {
        URL(string: Config.baseURL)!
    }
    
    var path: String {
        switch self {
        case .dailyBoxOffice:
            "/searchDailyBoxOfficeList.json"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .dailyBoxOffice:
                .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .dailyBoxOffice(let date):
            let parameters = [
                "key": Config.boxOfficeAPIKey,
                "targetDt": date
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .dailyBoxOffice:
            ["Content-Type": "application/json"]
        }
    }
}
