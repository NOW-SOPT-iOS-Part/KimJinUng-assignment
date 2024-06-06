//
//  DefaultFindViewModel.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 5/26/24.
//

import Foundation

import RxSwift
import RxRelay

final class DefaultFindViewModel {
    
    // MARK: - Input Relay
    
    private let viewDidLoadRelay = PublishRelay<String>()
    
    // MARK: - Property
    
    private let boxOfficeService: DefaultNetworkService<BoxOfficeTargetType>
    
    // MARK: - Initializer
    
    init(boxOfficeService: DefaultNetworkService<BoxOfficeTargetType>) {
        self.boxOfficeService = boxOfficeService
    }
}

extension DefaultFindViewModel: FindViewModel {
    
    // MARK: - Output
    
    var isViewDidLoad: Observable<[DailyBoxOfficeList]> { setIsViewDidLoad() }
    
    // MARK: - Input
    
    func viewDidLoad() {
        guard let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) else { return }
        viewDidLoadRelay.accept(yesterday.toString(with: .yyyyMMdd))
    }
}

private extension DefaultFindViewModel {
    func setIsViewDidLoad() -> Observable<[DailyBoxOfficeList]> {
        return viewDidLoadRelay
            .flatMap { [weak self] dateString -> Observable<[DailyBoxOfficeList]> in
                guard let self else { return .error(AppError.unknown) }
                return createObservableForDate(dateString)
            }
    }
    
    func createObservableForDate(_ dateString: String) -> Observable<[DailyBoxOfficeList]> {
        return Observable.create { [weak self] observer in
            self?.boxOfficeService.request(
                for: .dailyBoxOffice(date: dateString),
                completion: { result in
                    self?.handleResult(result, observer: observer)
                }
            )
            return Disposables.create()
        }
    }
    
    func handleResult(_ result: NetworkResult<DailyBoxOffice>, observer: AnyObserver<[DailyBoxOfficeList]>) {
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
