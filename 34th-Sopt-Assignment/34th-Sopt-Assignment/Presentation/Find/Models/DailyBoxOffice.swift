//
//  DailyBoxOffice.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 5/10/24.
//

import Foundation

// MARK: - DailyBoxOffice

struct DailyBoxOffice: Codable {
    let boxOfficeResult: BoxOfficeResult
}

// MARK: - BoxOfficeResult

struct BoxOfficeResult: Codable {
    let boxofficeType, showRange: String
    let dailyBoxOfficeList: [DailyBoxOfficeList]
}

// MARK: - DailyBoxOfficeList

struct DailyBoxOfficeList: Codable {
    let rank, movieTitle, audienceNumber: String
    
    enum CodingKeys: String, CodingKey {
        case rank
        case movieTitle = "movieNm"
        case audienceNumber = "audiAcc"
    }
}
