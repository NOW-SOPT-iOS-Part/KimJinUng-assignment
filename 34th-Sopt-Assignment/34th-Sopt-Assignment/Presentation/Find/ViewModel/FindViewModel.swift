//
//  FindViewModel.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 5/26/24.
//

import Foundation

import RxSwift
import RxCocoa

final class FindViewModel {
    private let movieService: MovieServiceType
    
    private let _dailyBoxOfficeList = BehaviorRelay<[DailyBoxOfficeList]>(value: [])
    
    init(movieService: MovieServiceType) {
        self.movieService = movieService
    }
}

extension FindViewModel: ViewModelType {
    struct Input {
        let viewDidLoad: Observable<Date>
        let backButtonDidTap: Observable<Void>
    }
    
    struct Output {
        let dailyBoxOfficeList: Driver<[DailyBoxOfficeList]>
        let popViewController: Driver<Void>
    }
    
    func transform(from input: Input, with disposeBag: DisposeBag) -> Output {
        input.viewDidLoad
            .flatMap { [weak self] date -> Observable<[DailyBoxOfficeList]> in
                let dateString = date.toString(with: .yyyyMMdd)
                guard let result = self?.movieService.fetchDailyBoxOfficeList(
                    dateString: dateString
                ) else {
                    return .error(AppError.unknown)
                }
                
                return result
            }
            .bind(to: _dailyBoxOfficeList)
            .disposed(by: disposeBag)
        
        let popViewController = input.backButtonDidTap
            .asDriver(onErrorJustReturn: ())
        
        let output = Output(
            dailyBoxOfficeList: _dailyBoxOfficeList.asDriver(),
            popViewController: popViewController
        )
        
        return output
    }
}
