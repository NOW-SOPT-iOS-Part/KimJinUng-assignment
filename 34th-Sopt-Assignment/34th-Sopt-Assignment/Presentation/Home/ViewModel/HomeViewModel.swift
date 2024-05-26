//
//  HomeViewModel.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 5/26/24.
//

import RxSwift
import RxRelay
import RxCocoa

final class HomeViewModel: ViewModelType {
    struct Input {
        
    }
    
    struct Output {
        let viewDidLoad: Observable<[HomeViewController.Section]>
    }
    
    func transform(from input: Input = Input(), disposeBag: DisposeBag) -> Output {
        let mockData: [HomeViewController.Section] = [
            .main(Program.main),
            .mostViewed(Program.mostViewed),
            .longLogo(Program.longLogo),
            .recommend(Program.recommend),
            .paramounts(Program.paramounts)
        ]
        let viewDidLoad = Observable.just(mockData)
        
        let output = Output(viewDidLoad: viewDidLoad)
        return output
    }
}
