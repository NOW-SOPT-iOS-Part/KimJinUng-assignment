//
//  ViewModelType.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 6/16/24.
//

import RxSwift

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(from input: Input, with disposeBag: RxSwift.DisposeBag) -> Output
}
