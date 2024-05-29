//
//  DefaultFindViewModel.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 5/26/24.
//

import Foundation

import RxSwift
import RxRelay

final class DefaultFindViewModel: FindViewModel {
    
    // MARK: - Output
    
    private(set) lazy var isViewDidLoad: Observable<[DailyBoxOfficeList]> = setIsViewDidLoad()
    
    // MARK: - Input Relay
    
    private let viewDidLoadRelay = PublishRelay<String>()
    
    // MARK: - Input
    
    func viewDidLoad() {
        guard let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) else { return }
        viewDidLoadRelay.accept(yesterday.toString(with: .yyyyMMdd))
    }
}

private extension DefaultFindViewModel {
    func setIsViewDidLoad() -> Observable<[DailyBoxOfficeList]> {
        return viewDidLoadRelay
            .flatMap { dateString -> Observable<[DailyBoxOfficeList]> in
                
                // TODO: 네트워크 작업 수행 및 결과 리턴
                
                return .just([])
            }
    }
}
