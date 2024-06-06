//
//  DefaultHomeViewModel.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 5/26/24.
//

import RxSwift
import RxRelay

final class DefaultHomeViewModel {
    
    // MARK: - Input Relay

    private let viewDidLoadRelay = PublishRelay<Void>()
}

extension DefaultHomeViewModel: HomeViewModel {
    
    // MARK: - Output
    
    var isViewDidLoad: Observable<[HomeViewController.Section]> { setIsViewDidLoad() }
    
    // MARK: - Input
    
    func viewDidLoad() {
        viewDidLoadRelay.accept(())
    }
}

private extension DefaultHomeViewModel {
    func setIsViewDidLoad() -> Observable<[HomeViewController.Section]> {
        return viewDidLoadRelay
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
    }
}
