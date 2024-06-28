//
//  HomeViewModel.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 5/26/24.
//

import RxCocoa
import RxSwift
                                
final class HomeViewModel {
    struct Section {
        let type: SectionType
        let items: [Program]
    }
    
    enum SectionType: CaseIterable {
        case main, mostViewed, longLogo, recommend, paramounts
    }
    
    var sections: [Section] { sectionRelay.value }
    
    private let sectionRelay = BehaviorRelay<[Section]>(value: [])
}

extension HomeViewModel: ViewModelType {
    struct Input {
        let viewDidLoad: Observable<Void>
        let selectedSegmentIndexChanged: Observable<Int>
    }
    
    struct Output {
        let sections: Driver<[Section]>
        let showSelectedSegmentView: Driver<Int>
    }
    
    func transform(from input: Input, with disposeBag: DisposeBag) -> Output {
        let sections = input.viewDidLoad
            .map { _ -> [Section] in
                return [
                    Section(type: .main, items: Program.main),
                    Section(type: .mostViewed, items: Program.mostViewed),
                    Section(type: .longLogo, items: Program.longLogo),
                    Section(type: .recommend, items: Program.recommend),
                    Section(type: .paramounts, items: Program.paramounts),
                ]
            }
            .do(onNext: { [weak self] sections in
                self?.sectionRelay.accept(sections)
            })
            .asDriver(onErrorJustReturn: [])
        
        let showSelectedSegmentView = input.selectedSegmentIndexChanged
            .asDriver(onErrorJustReturn: 0)
        
        let output = Output(
            sections: sections,
            showSelectedSegmentView: showSelectedSegmentView
        )
        
        return output
    }
}
