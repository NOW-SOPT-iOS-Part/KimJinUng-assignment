//
//  HomeViewModel.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 5/26/24.
//

import RxSwift
import RxRelay

protocol HomeViewModelInput {
    func viewDidLoad()
}

protocol HomeViewModelOutput {
    var isViewDidLoad: Observable<[HomeViewController.Section]>? { get }
}

typealias HomeViewModel = HomeViewModelInput & HomeViewModelOutput

final class DefaultHomeViewModel: HomeViewModel {
    
    // MARK: - Output

    private(set) var isViewDidLoad: Observable<[HomeViewController.Section]>?
    
    // MARK: - Property

    private let viewDidLoadRelay = PublishRelay<Void>()
    
    // MARK: - Initializer

    init() {
        setOutput()
    }
    
    // MARK: - Input

    func viewDidLoad() {
        viewDidLoadRelay.accept(())
    }
}

private extension DefaultHomeViewModel {
    func setOutput() {
        isViewDidLoad = viewDidLoadRelay
            .flatMap { _ -> Observable<[HomeViewController.Section]> in
                let mockData: [HomeViewController.Section] = [
                    .main(Program.main),
                    .mostViewed(Program.mostViewed),
                    .longLogo(Program.longLogo),
                    .recommend(Program.recommend),
                    .paramounts(Program.paramounts)
                ]
                return Observable.just(mockData)
        }
    }
}
