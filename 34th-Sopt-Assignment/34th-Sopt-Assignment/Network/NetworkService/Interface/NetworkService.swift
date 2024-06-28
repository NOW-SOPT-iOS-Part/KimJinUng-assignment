//
//  NetworkService.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 5/29/24.
//

import Moya

protocol NetworkService {
    associatedtype T: TargetType
    
    func request<D: Codable>(for target: T, completion: @escaping (NetworkResult<D>) -> Void)
}
