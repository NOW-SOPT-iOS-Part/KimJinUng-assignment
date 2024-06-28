//
//  FindViewController.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 5/10/24.
//

import UIKit

import RxCocoa
import RxSwift

final class FindViewController: UIViewController, AlertShowable {
    
    // MARK: - Property
    
    private let viewModel: FindViewModel
    private let disposeBag = DisposeBag()
    private let rootView = FindView()
    
    // MARK: - Initializer
    
    init(viewModel: FindViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        
        bindViewModel()
    }
}

private extension FindViewController {
    
    // MARK: - ViewModel Binding
    
    func bindViewModel() {
        guard let yesterday = Calendar.current.date(
            byAdding: .day,
            value: -1,
            to: Date()
        ) else {
            return
        }
        
        let input = FindViewModel.Input(
            viewDidLoad: .just(yesterday),
            backButtonDidTap: rootView.backButtonDidTap
        )
        
        let output = viewModel.transform(from: input, with: disposeBag)
        
        output.dailyBoxOfficeList
            .drive(rootView.boxOfficeListView.rx.items(
                cellIdentifier: BoxOfficeCell.reuseIdentifier,
                cellType: BoxOfficeCell.self
            )) { index, movie, cell in
                cell.bind(rank: movie.rank, title: movie.title, number: movie.audienceNumber)
            }
            .disposed(by: disposeBag)
        
        output.popViewController
            .drive(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
}
