//
//  BoxOfficeService.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 5/10/24.
//

import Foundation

import Moya

final class BoxOfficeService {
    static let shared = BoxOfficeService()
    
    private var boxOfficeProvider = MoyaProvider<BoxOfficeTargetType>(plugins: [MoyaLoggingPlugin()])
    
    private init() {}
}

extension BoxOfficeService {
    func fetchBoxOfficeList(date: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        boxOfficeProvider.request(.dailyBoxOffice(date: date)) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                let networkResult = judgeStatus(by: response.statusCode, response.data, DailyBoxOffice.self)
                completion(networkResult)
            case .failure(let failure):
                completion(.networkFail)
            }
        }
    }
    
    private func judgeStatus<T: Codable>(by statusCode: Int, _ data: Data, _ object: T.Type) -> NetworkResult<Any> {
        switch statusCode {
        case 200..<205:
            return isValidData(data: data, T.self)
        case 400..<500:
            return .requestErr
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
    
    private func isValidData<T: Codable>(data: Data, _ object: T.Type) -> NetworkResult<Any> {
        guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
            print("⛔️ \(self)에서 디코딩 오류가 발생했습니다 ⛔️")
            return .pathErr
        }
        return .success(decodedData as Any)
    }
}
