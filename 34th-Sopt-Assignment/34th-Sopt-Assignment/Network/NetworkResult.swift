//
//  NetworkResult.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 5/10/24.
//

import Foundation

enum NetworkResult<T> {
    case success(T)
    case requestErr
    case decodedErr
    case pathErr
    case serverErr
    case networkFail
}
