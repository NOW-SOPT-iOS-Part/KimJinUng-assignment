//
//  ReuseIdentifiable.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 4/29/24.
//

import Foundation

protocol ReuseIdentifiable {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifiable {
    static var reuseIdentifier: String { String(describing: Self.self) }
}
