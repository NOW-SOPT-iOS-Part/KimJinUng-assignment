//
//  HomeViewModel.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 5/29/24.
//

import RxSwift
import RxCocoa

protocol HomeViewModelInput {
    func viewDidLoad()
}

protocol HomeViewModelOutput {
    var isViewDidLoad: Driver<[HomeViewController.Section]> { get }
}

typealias HomeViewModel = HomeViewModelInput & HomeViewModelOutput
