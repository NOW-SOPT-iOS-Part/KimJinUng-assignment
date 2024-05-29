//
//  FindViewController.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 5/10/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class FindViewController: UIViewController, AlertShowable {
    
    // MARK: - UIComponent
    
    private let backButton = UIButton()
    private let findTextField = TvingTextField(placeholder: "내용을 입력해주세요.")
    private let titleLabel = UILabel()
    private let boxOfficeListView = UITableView()
    
    // MARK: - Property
    
    private var dailyBoxOfficeList = [DailyBoxOfficeList]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.boxOfficeListView.reloadData()
            }
        }
    }
    
    private let viewModel: FindViewModel
    private let disposeBag = DisposeBag()
    
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
        
        setUI()
        setViewHierarchy()
        setAutoLayout()
        setDelegate()
        
        bindViewModel()
        bindAction()
        
        viewModel.viewDidLoad()
    }
}

private extension FindViewController {
    
    // MARK: - ViewModel Binding

    func bindViewModel() {
        viewModel.isViewDidLoad.subscribe(onNext: { [weak self] data in
            self?.dailyBoxOfficeList = data
        }, onError: { [weak self] error in
            if let error = error as? AppError {
                self?.showAlert(title: error.title, message: error.message)
            }
            print(error)
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Action Binding

    func bindAction() {
        backButton.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
    }
}

// MARK: - UITableViewDelegate

extension FindViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

// MARK: - UITableViewDataSource

extension FindViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyBoxOfficeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: BoxOfficeCell.reuseIdentifier,
            for: indexPath
        ) as? BoxOfficeCell else { return UITableViewCell() }
        let movie = dailyBoxOfficeList[indexPath.row]
        cell.bind(rank: movie.rank, title: movie.title, number: movie.audienceNumber)
        return cell
    }
}

private extension FindViewController {
    
    // MARK: - SetUI
    
    func setUI() {
        view.backgroundColor = .black
        navigationItem.hidesBackButton = true
        
        backButton.setImage(UIImage(resource: .btnBefore), for: .normal)
        
        titleLabel.setText("일일 박스오피스 순위", color: .white, font: .pretendard(.semiBold, size: 15))
        
        boxOfficeListView.do {
            $0.backgroundColor = .black
            $0.register(BoxOfficeCell.self, forCellReuseIdentifier: BoxOfficeCell.reuseIdentifier)
        }
    }
    
    func setViewHierarchy() {
        view.addSubviews(backButton, findTextField, titleLabel, boxOfficeListView)
    }
    
    // MARK: - AutoLayout
    
    func setAutoLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        backButton.snp.makeConstraints {
            $0.top.equalTo(safeArea)
            $0.leading.equalTo(safeArea).offset(20)
            $0.size.equalTo(20)
        }
        
        findTextField.snp.makeConstraints {
            $0.centerY.equalTo(backButton)
            $0.leading.equalTo(backButton.snp.trailing).offset(10)
            $0.trailing.equalTo(safeArea).offset(-20)
            $0.height.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(40)
            $0.leading.equalTo(backButton)
        }
        
        boxOfficeListView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(safeArea)
        }
    }
    
    // MARK: - Delegate
    
    func setDelegate() {
        boxOfficeListView.delegate = self
        boxOfficeListView.dataSource = self
    }
}
