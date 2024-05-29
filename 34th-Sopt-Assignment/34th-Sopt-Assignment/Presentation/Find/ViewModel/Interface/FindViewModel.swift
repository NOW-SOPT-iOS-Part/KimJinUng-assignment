//
//  FindViewModel.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 5/29/24.
//

import RxSwift

protocol FindViewModelInput {
    func viewDidLoad()
}

protocol FindViewModelOutput {
    var isViewDidLoad: Observable<[DailyBoxOfficeList]> { get }
}

typealias FindViewModel = FindViewModelInput & FindViewModelOutput
