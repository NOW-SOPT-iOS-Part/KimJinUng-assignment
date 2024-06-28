//
//  MovieService.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 6/29/24.
//

import Foundation

import Moya
import RxSwift
import RxMoya

protocol MovieServiceType {
    func fetchDailyBoxOfficeList(dateString: String) -> Observable<[DailyBoxOfficeList]>
}

final class MovieService {
    private let provider = MoyaProvider<BoxOfficeTargetType>(plugins: [MoyaLoggingPlugin()])
}

extension MovieService: MovieServiceType {
    func fetchDailyBoxOfficeList(dateString: String) -> Observable<[DailyBoxOfficeList]> {
        return provider.rx.request(.dailyBoxOffice(date: dateString))
            .filterSuccessfulStatusCodes()
            .map(DailyBoxOffice.self)
            .map { $0.boxOfficeResult.dailyBoxOfficeList }
            .asObservable()
            .catch { error in
                print("에러 발생: \(error.localizedDescription)")
                return .just([])
            }
    }
}
