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
        var flag = false
        
        if let input = sender.text, !input.isEmpty {
            flag = true
        }
        toggleSaveButton(flag)
    }
    
    private func toggleSaveButton(_ flag: Bool) {
        let titleColor: UIColor = flag ? .white : .gray2
        let backgroundColor: UIColor = flag ? .tvingRed : .black
        let borderWidth: CGFloat = flag ? 0 : 1
        
        saveButton.setTitleColor(titleColor, for: .normal)
        saveButton.backgroundColor = backgroundColor
        saveButton.layer.borderWidth = borderWidth
        saveButton.isEnabled = flag
    }
    
    @objc
    private func saveButtonTapped(_ sender: UIButton) {
        do {
            let nickname = try checkNickname(nicknameTextField.text)
            delegate?.configure(nickname: nickname)
            dismiss(animated: true)
        } catch let appError as AppError {
            showAlert(title: "\(appError)", message: "\(appError.message)")
        } catch {
            print("\(error.localizedDescription)")
        }
    }
    
    private func checkNickname(_ input: String?) throws -> String {
        guard let nickname = input,
              checkFrom(input: nickname, regex: .nickname)
        else {
            throw AppError.nickname
        }
        return nickname
    }
}

private extension MakeNicknameViewController {
    
    // MARK: - SetUI
    
    func setUI() {
        view.backgroundColor = .systemBackground
        
        titleLabel.setText(
            "닉네임을 입력해주세요",
            color: .black,
            font: .pretendard(weight: .five, size: 23)
        )
        
        nicknameTextField.do {
            $0.setText(
                placeholder: "아요짱~",
                textColor: .black,
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
            $0.backgroundColor = .black
            $0.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
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
