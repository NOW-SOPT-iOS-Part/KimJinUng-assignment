//
//  TvingTextField.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 4/23/24.
//

import UIKit

final class TvingTextField: UITextField {
    
    init(placeholder: String, type: InputType? = nil) {
        super.init(frame: .zero)
        setUI(with: placeholder)
        configure(for: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI(with placeholder: String?) {
        setText(
            placeholder: placeholder ?? "",
            textColor: .white,
            backgroundColor: .grayFrom(hex: .scale_2E2E2E),
            placeholderColor: .grayFrom(hex: .scale_9C9C9C),
            font: .pretendard(.semiBold, size: 15)
        )
        setAutoType()
        setLayer(borderColor: .white)
        addPadding(left: 20)
    }
    
    private func configure(for type: InputType?) {
        guard let type else { return }
        keyboardType = type.keyboardType
        rightViewMode = type.rightViewMode
        isSecureTextEntry = type.isSecureTextEntry
    }
}

extension TvingTextField {
    enum InputType {
        case id, pw, nickname
        
        var keyboardType: UIKeyboardType {
            switch self {
            case .id:
                    .emailAddress
            default:
                    .default
            }
        }
        
        var rightViewMode: UITextField.ViewMode {
            switch self {
            case .id:
                    .whileEditing
            case .pw:
                    .whileEditing
            default:
                    .never
            }
        }
        
        var isSecureTextEntry: Bool {
            switch self {
            case .pw:
                true
            default:
                false
            }
        }
    }
}
