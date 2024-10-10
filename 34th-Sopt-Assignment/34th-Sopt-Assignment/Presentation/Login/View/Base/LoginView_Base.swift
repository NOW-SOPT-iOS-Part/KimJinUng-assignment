//
//  LoginView_Base.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 7/3/24.
//

import UIKit

import SnapKit
import Then

final class LoginView_Base: BaseView {
    
    
    // MARK: - Component
    
    private let titleLabel = UILabel().then {
        $0.setText("TVING ID 로그인", color: .gray1, font: .pretendard(.medium, size: 23))
        $0.textAlignment = .center
    }
    
    let idTextField = TvingTextField(placeholder: "아이디", type: .id)
    
    private let idTextFieldRightView = UIView()
    
    let idClearButton = UIButton().then {
        $0.setImage(UIImage(resource: .xCircle), for: .normal)
    }
    
    let pwTextField = TvingTextField(placeholder: "비밀번호", type: .pw)
    
    private let pwTextFieldRightView = UIView()
    
    let pwClearButton = UIButton().then {
        $0.setImage(UIImage(resource: .xCircle), for: .normal)
    }
    
    let pwShowButton = UIButton().then {
        $0.setImage(UIImage(resource: .eyeSlash), for: .normal)
    }
    
    let loginButton = UIButton().then {
        $0.setTitle(
            title: "로그인하기",
            titleColor: .gray2,
            font: .pretendard(.semiBold, size: 14)
        )
        $0.setLayer(borderWidth: 1)
        $0.isEnabled = false
        $0.backgroundColor = .black
    }
    
    private let findIDButton = UIButton().then {
        $0.setTitle(title: "아이디 찾기", titleColor: .gray2, font: .pretendard(.semiBold, size: 14))
    }
    
    private let divider = UIView(backgroundColor: .gray4)
    
    private let findPWButton = UIButton().then {
        $0.setTitle(title: "비밀번호 찾기", titleColor: .gray2, font: .pretendard(.semiBold, size: 14))
    }
    
    private let helpButton = UIButton().then {
        $0.setTitle(
            title: "아직 계정이 없으신가요?",
            titleColor: .gray3,
            font: .pretendard(.semiBold, size: 14)
        )
    }
    
    let nicknameButton = UIButton().then {
        $0.setTitle(
            title: "닉네임 만들러가기",
            titleColor: .gray2,
            font: .pretendard(.regular, size: 14)
        )
        $0.addUnderline()
    }

    override func setupView() {
        backgroundColor = .black
        
        idTextField.rightView = idTextFieldRightView
        
        pwTextField.rightView = pwTextFieldRightView
        
        addSubviews(
            titleLabel, idTextField, pwTextField, loginButton, findIDButton,
            divider, findPWButton, helpButton, nicknameButton
        )
        
        idTextFieldRightView.addSubview(idClearButton)
        pwTextFieldRightView.addSubviews(pwShowButton, pwClearButton)
    }
    
    override func setupAutoLayout() {
        let safeArea = safeAreaLayoutGuide
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(safeArea.snp.top).offset(50)
        }
        
        idTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.horizontalEdges.equalTo(safeArea).inset(20)
            $0.height.equalTo(Constants.UI.textFieldAndButtonHeight)
        }
        
        idTextFieldRightView.snp.makeConstraints {
            $0.width.equalTo(35)
            $0.height.equalTo(Constants.UI.textFieldAndButtonHeight)
        }
        
        idClearButton.snp.makeConstraints {
            $0.size.equalTo(20)
            $0.leading.centerY.equalTo(idTextFieldRightView)
        }
        
        pwTextField.snp.makeConstraints {
            $0.top.equalTo(idTextField.snp.bottom).offset(7)
            $0.horizontalEdges.height.equalTo(idTextField)
        }
        
        pwTextFieldRightView.snp.makeConstraints {
            $0.width.equalTo(70)
            $0.height.equalTo(Constants.UI.textFieldAndButtonHeight)
        }
        
        pwShowButton.snp.makeConstraints {
            $0.size.equalTo(20)
            $0.leading.centerY.equalTo(pwTextFieldRightView)
        }
        
        pwClearButton.snp.makeConstraints {
            $0.size.equalTo(20)
            $0.trailing.equalTo(pwTextFieldRightView.snp.trailing).offset(-20)
            $0.centerY.equalTo(pwTextFieldRightView)
        }
        
        loginButton.snp.makeConstraints {
            $0.top.equalTo(pwTextField.snp.bottom).offset(20)
            $0.horizontalEdges.height.equalTo(idTextField)
        }
        
        findIDButton.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(30)
            $0.leading.equalTo(safeArea.snp.leading).offset(85)
            $0.height.equalTo(22)
        }
        
        divider.snp.makeConstraints {
            $0.centerY.equalTo(findIDButton)
            $0.centerX.equalToSuperview().offset(-2)
            $0.width.equalTo(1)
            $0.height.equalTo(12)
        }
        
        findPWButton.snp.makeConstraints {
            $0.top.height.equalTo(findIDButton)
            $0.trailing.equalTo(safeArea.snp.trailing).offset(-85)
        }
        
        helpButton.snp.makeConstraints {
            $0.top.equalTo(findIDButton.snp.bottom).offset(30)
            $0.leading.equalTo(safeArea.snp.leading).offset(50)
            $0.height.equalTo(findIDButton)
        }
        
        nicknameButton.snp.makeConstraints {
            $0.top.height.equalTo(helpButton)
            $0.trailing.equalTo(safeArea.snp.trailing).offset(-50)
            $0.width.equalTo(128)
        }
    }
}
