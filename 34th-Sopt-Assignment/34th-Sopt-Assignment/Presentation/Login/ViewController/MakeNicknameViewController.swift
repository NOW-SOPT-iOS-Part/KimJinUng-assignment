//
//  MakeNicknameViewController.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 4/17/24.
//

import UIKit

import RxCocoa
import RxSwift

protocol MakeNicknameViewDelegate: AnyObject {
    func configure(nickname: String)
}

final class MakeNicknameViewController: UIViewController, AlertShowable {
    
    // MARK: - Property
    
    private weak var delegate: MakeNicknameViewDelegate?
    
    private let viewModel: MakeNicknameViewModel
    private let disposeBag = DisposeBag()
    private let rootView = MakeNicknameView()
    
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
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

private extension MakeNicknameViewController {
    
    // MARK: - ViewModel Binding
    
    func bindViewModel() {
        let input = MakeNicknameViewModel.Input(
            nicknameTextFieldDidChange: rootView.nicknameTextFieldDidChange,
            saveButtonDidTap: rootView.saveButtonDidTap
        )
        
        let output = viewModel.transform(from: input, with: disposeBag)
        
        output.isSaveEnabled
            .drive(with: self) { owner, flag in
                owner.rootView.toggleSaveButton(flag)
            }
            .disposed(by: disposeBag)
        
        output.isSucceedToSave
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
