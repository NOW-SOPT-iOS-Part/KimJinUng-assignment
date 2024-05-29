//
//  NetworkService.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 5/10/24.
//

import Foundation

import Moya

final class DefaultNetworkService<T: TargetType> {
    private let provider: MoyaProvider<T>
    
    init(provider: MoyaProvider<T> = MoyaProvider<T>(plugins: [MoyaLoggingPlugin()])) {
        self.provider = provider
    }
}

extension DefaultNetworkService: NetworkService {
    func request<D: Codable>(for target: T, completion: @escaping (NetworkResult<D>) -> Void) {
        provider.request(target) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                let networkResult = judgeStatus(
                    by: response.statusCode,
                    response.data,
                    D.self
                )
                completion(networkResult)
            case .failure:
                completion(.networkFail)
            }
        }
    }
}

private extension DefaultNetworkService {
    func judgeStatus<D: Codable>(
        by statusCode: Int,
        _ data: Data,
        _ object: D.Type
    ) -> NetworkResult<D> {
        switch statusCode {
        case 200..<205:
            return isValidData(data: data, D.self)
        case 400..<500:
            return .requestErr
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
    
    func isValidData<D: Codable>(data: Data, _ object: D.Type) -> NetworkResult<D> {
        guard let decodedData = try? JSONDecoder().decode(D.self, from: data) else {
            print("⛔️ \(self)에서 디코딩 오류가 발생했습니다 ⛔️")
            return .pathErr
        }
        return .success(decodedData)
    }
}
