//
//  BoxOfficeViewModel.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 5/29/24.
//

import RxSwift

protocol BoxOfficeViewModelInput {
    func viewDidLoad(_ dateString: String)
}

protocol BoxOfficeViewModelOutput {
    var isViewDidLoad: Observable<[DailyBoxOfficeList]>? { get }
}

typealias FindViewModel = BoxOfficeViewModelInput & BoxOfficeViewModelOutput
