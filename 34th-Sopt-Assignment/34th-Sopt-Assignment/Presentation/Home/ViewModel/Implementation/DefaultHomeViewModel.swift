//
//  DefaultHomeViewModel.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 5/26/24.
//

import RxSwift
import RxCocoa

final class DefaultHomeViewModel {
    
    // MARK: - Input Relay
    
    private let viewDidLoadRelay = PublishRelay<Void>()
}

extension DefaultHomeViewModel: HomeViewModel {
    
    // MARK: - Output
    
    var isViewDidLoad: Driver<[HomeViewController.Section]> {
        viewDidLoadRelay
            .flatMap { _ -> Observable<[HomeViewController.Section]> in
                let mockData: [HomeViewController.Section] = [
                    .main(Program.main),
                    .mostViewed(Program.mostViewed),
                    .longLogo(Program.longLogo),
                    .recommend(Program.recommend),
                    .paramounts(Program.paramounts)
                ]
                return .just(mockData)
            }
            .asDriver(onErrorJustReturn: [])
    }
    
    // MARK: - Input
    
    func viewDidLoad() {
        viewDidLoadRelay.accept(())
    }
}
