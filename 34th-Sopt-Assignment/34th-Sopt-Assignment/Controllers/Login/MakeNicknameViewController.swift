//
//  MakeNicknameViewController.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 4/17/24.
//

import Then
import UIKit
import SnapKit

protocol MakeNicknameViewDelegate: AnyObject {
    func configure(nickname: String)
}

final class MakeNicknameViewController: UIViewController, RegexCheckable, AlertShowable {
    
    // MARK: - Component
    
    private let titleLabel = UILabel()
    
    private let nicknameTextField = UITextField()
    
    private let saveButton = UIButton()
    
    // MARK: - Property
    
    weak var delegate: MakeNicknameViewDelegate?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setViewHierarchy()
        setAutoLayout()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - Action
    
    @objc
    private func nicknameTextFieldEditingChanged(_ sender: UITextField) {
        guard let input = sender.text,
              !input.isEmpty
        else {
            disableSaveButton()
            return
        }
        enableSaveButton()
    }
    
    private func disableSaveButton() {
        saveButton.do {
            $0.setLayer(borderColor: .gray4, borderWidth: 1, cornerRadius: 12)
            $0.setTitleColor(.gray2, for: .normal)
            $0.backgroundColor = .basicBlack
            $0.isEnabled = false
        }
    }
    
    private func enableSaveButton() {
        saveButton.do {
            $0.setTitleColor(.basicWhite, for: .normal)
            $0.backgroundColor = .brandRed
            $0.layer.borderWidth = 0
            $0.isEnabled = true
        }
    }
    
    @objc
    private func saveButtonTapped(_ sender: UIButton) {
        print(#function)
        do {
            let nickname = try checkNickname()
            delegate?.configure(nickname: nickname)
            dismiss(animated: true)
        } catch {
            let error = error as! AppError
            showAlert(title: "\(error)", message: "\(error.message)")
        }
    }
    
    private func checkNickname() throws -> String {
        guard let input = nicknameTextField.text,
              checkFrom(input: input, regex: .nickname)
        else {
            throw AppError.nickname
        }
        return input
    }
}

extension MakeNicknameViewController {
    
    // MARK: - SetUI
    
    private func setUI() {
        view.backgroundColor = .systemBackground
        
        titleLabel.setText(
            "닉네임을 입력해주세요",
            color: .basicBlack,
            font: .pretendard(weight: .five, size: 23)
        )
        
        nicknameTextField.do {
            $0.setText(
                placeholder: "아요짱~",
                textColor: .basicBlack,
                backgroundColor: .grayFrom(hex: .scale_9C9C9C),
                placeholderColor: .gray1,
                font: .pretendard(weight: .six, size: 15)
            )
            $0.addPadding(left: 25)
            $0.layer.cornerRadius = Constants.UI.cornerRadius
            $0.addTarget(self, action: #selector(nicknameTextFieldEditingChanged), for: .editingChanged)
        }
        
        saveButton.do {
            $0.setTitle(title: "저장하기", titleColor: .gray2, font: .pretendard(weight: .six, size: 14))
            $0.setLayer(borderColor: .gray4, borderWidth: 1, cornerRadius: 12)
            $0.isEnabled = false
            $0.backgroundColor = .basicBlack
            $0.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        }
    }
    
    private func setViewHierarchy() {
        view.addSubviews(titleLabel, nicknameTextField, saveButton)
    }
    
    // MARK: - AutoLayout
    
    private func setAutoLayout() {
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
            $0.leading.trailing.height.equalTo(nicknameTextField)
        }
    }
}
