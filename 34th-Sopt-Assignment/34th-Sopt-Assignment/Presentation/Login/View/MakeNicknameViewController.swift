//
//  MakeNicknameViewController.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 4/17/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

protocol MakeNicknameViewDelegate: AnyObject {
    func configure(nickname: String)
}

final class MakeNicknameViewController: UIViewController, AlertShowable {
    
    // MARK: - Component
    
    private let titleLabel = UILabel()
    private let nicknameTextField = TvingTextField(placeholder: "닉네임", type: .nickname)
    private let saveButton = UIButton()
    
    // MARK: - Property
    
    private weak var delegate: MakeNicknameViewDelegate?
    
    private let viewModel: MakeNicknameViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializer
    
    init(delegate: MakeNicknameViewDelegate?, viewModel: MakeNicknameViewModel) {
        self.delegate = delegate
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
        
        bindViewModel()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

private extension MakeNicknameViewController {
    
    // MARK: - ViewModel Binding
    
    func bindViewModel() {
        nicknameTextField.rx.text
            .subscribe(onNext: { [weak self] text in
                self?.viewModel.nicknameTextFieldDidChange(text)
            })
            .disposed(by: disposeBag)
        
        saveButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.saveButtonDidTap()
            })
            .disposed(by: disposeBag)
        
        viewModel.isSaveEnabled
            .drive(with: self) { owner, flag in
                owner.toggleSaveButton(flag)
            }
            .disposed(by: disposeBag)
        
        viewModel.isSucceedToSave
            .drive(with: self) { owner, result in
                switch result {
                case .success(let nickname):
                    owner.delegate?.configure(nickname: nickname)
                    owner.dismiss(animated: true)
                case .failure(let error):
                    owner.showAlert(title: error.title, message: error.message)
                }
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Private method

private extension MakeNicknameViewController {
    func toggleSaveButton(_ flag: Bool) {
        let titleColor: UIColor = flag ? .white : .gray2
        let backgroundColor: UIColor = flag ? .tvingRed : .black
        let borderWidth: CGFloat = flag ? 0 : 1
        
        saveButton.setTitleColor(titleColor, for: .normal)
        saveButton.backgroundColor = backgroundColor
        saveButton.layer.borderWidth = borderWidth
        saveButton.isEnabled = flag
    }
}

private extension MakeNicknameViewController {
    
    // MARK: - SetUI
    
    func setUI() {
        view.backgroundColor = .systemBackground
        
        titleLabel.setText(
            "닉네임을 입력해주세요",
            color: .black,
            font: .pretendard(.medium, size: 23)
        )
        
        saveButton.do {
            $0.setTitle(
                title: "저장하기",
                titleColor: .gray2,
                font: .pretendard(.semiBold, size: 14)
            )
            $0.setLayer(borderWidth: 1, cornerRadius: 12)
            $0.isEnabled = false
            $0.backgroundColor = .black
        }
    }
    
    func setViewHierarchy() {
        view.addSubviews(titleLabel, nicknameTextField, saveButton)
    }
    
    // MARK: - AutoLayout
    
    func setAutoLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.leading.equalToSuperview().offset(20)
        }
        
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.equalTo(titleLabel)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(Constants.UI.textFieldAndButtonHeight)
        }
        
        saveButton.snp.makeConstraints {
            $0.bottom.equalTo(safeArea.snp.bottom).offset(-10)
            $0.horizontalEdges.height.equalTo(nicknameTextField)
        }
    }
}
