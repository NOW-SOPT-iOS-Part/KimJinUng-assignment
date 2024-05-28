//
//  DefaultBoxOfficeViewModel.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 5/26/24.
//

import RxSwift
import RxRelay

final class DefaultFindViewModel: FindViewModel {
    
    // MARK: - Output
    
    private(set) var isViewDidLoad: Observable<[DailyBoxOfficeList]>?
    
    // MARK: - Property
    
    private let viewDidLoadRelay = PublishRelay<String>()

    // MARK: - Initializer

    init() {
        setOutput()
    }
    
    // MARK: - Input
    
    func viewDidLoad(_ dateString: String) {
        viewDidLoadRelay.accept(dateString)
    }
}

private extension DefaultFindViewModel {
    func setOutput() {
        isViewDidLoad = viewDidLoadRelay
            .flatMap { [weak self] dateString -> Observable<[DailyBoxOfficeList]> in
                
                return .just([])
            }
    }
    
    func fetchData(with dateString: String) -> [DailyBoxOfficeList] {
        var temp = [DailyBoxOfficeList]()
        
        BoxOfficeService.shared.requestBoxOfficeList(
            date: dateString
        ) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                guard let dailyBoxOffice = data as? DailyBoxOffice else { return }
                temp = dailyBoxOffice.boxOfficeResult.dailyBoxOfficeList
            default:
                break
            }
        }
        
        return temp
    }
}
