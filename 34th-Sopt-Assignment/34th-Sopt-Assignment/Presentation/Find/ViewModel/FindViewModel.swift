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
    private let boxOfficeService: DefaultNetworkService<BoxOfficeTargetType>
    
    private let _dailyBoxOfficeList = BehaviorRelay<[DailyBoxOfficeList]>(value: [])
    
    init(boxOfficeService: DefaultNetworkService<BoxOfficeTargetType>) {
        self.boxOfficeService = boxOfficeService
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
                guard let self else { return .error(AppError.unknown) }
                return createObservableForDate(date.toString(with: .yyyyMMdd))
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

private extension FindViewModel {
    func createObservableForDate(_ dateString: String) -> Observable<[DailyBoxOfficeList]> {
        Observable.create { [weak self] observer in
            self?.boxOfficeService.request(
                for: .dailyBoxOffice(date: dateString),
                completion: { result in
                    self?.handleResult(result, observer: observer)
                }
            )
            return Disposables.create()
        }
    }
    
    func handleResult(
        _ result: NetworkResult<DailyBoxOffice>,
        observer: AnyObserver<[DailyBoxOfficeList]>
    ) {
        switch result {
        case .success(let dailyBoxOffice):
            observer.onNext(dailyBoxOffice.boxOfficeResult.dailyBoxOfficeList)
            observer.onCompleted()
        case .requestErr:
            print("요청 오류")
            observer.onError(AppError.unknown)
        case .decodedErr:
            print("디코딩 오류")
            observer.onError(AppError.unknown)
        case .pathErr:
            print("경로 오류")
            observer.onError(AppError.unknown)
        case .serverErr:
            print("서버 오류")
            observer.onError(AppError.unknown)
        case .networkFail:
            print("네트워크 오류")
            observer.onError(AppError.unknown)
        }
    }
}
