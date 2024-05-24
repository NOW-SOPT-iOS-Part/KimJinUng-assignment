//
//  FindViewController.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 5/10/24.
//

import UIKit

import Then
import SnapKit

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
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setViewHierarchy()
        setAutoLayout()
        setDelegate()
        
        fetchBoxOfficeList()
    }
    
    private func fetchBoxOfficeList() {
        guard let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) else { return }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let dateString = formatter.string(from: yesterday)
        
        BoxOfficeService.shared.requestBoxOfficeList(date: dateString) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                guard let dailyBoxOffice = data as? DailyBoxOffice else { return }
                dailyBoxOfficeList = dailyBoxOffice.boxOfficeResult.dailyBoxOfficeList
            case .requestErr:
                showAlert(title: "요청 오류", message: "요청 과정에서 오류가 발생하였습니다.")
            case .decodedErr:
                showAlert(title: "디코딩 오류", message: "디코딩 타입을 확인해 주세요.")
            case .pathErr:
                showAlert(title: "경로 오류", message: "요청 경로가 올바르지 않습니다.")
            case .serverErr:
                showAlert(title: "서버 오류", message: "서버가 불안정합니다. 잠시 후 다시 시도해 주세요.")
            case .networkFail:
                showAlert(title: "네트워크 오류", message: "기기의 통신 상태가 불안정합니다. 잠시 후 다시 시도해 주세요.")
            }
        }
    }
    
    // MARK: - Action
    
    @objc
    private func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
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
        
        backButton.do {
            $0.setImage(UIImage(resource: .btnBefore), for: .normal)
            $0.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        }
        
        titleLabel.do {
            $0.setText("일일 박스오피스 순위", color: .white, font: .pretendard(weight: .six, size: 15))
        }
        
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
