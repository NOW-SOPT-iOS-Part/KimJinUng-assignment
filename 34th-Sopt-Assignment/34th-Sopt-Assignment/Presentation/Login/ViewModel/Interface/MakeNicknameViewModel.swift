//
//  MakeNicknameViewModel.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 5/29/24.
//

import RxSwift
import RxCocoa

protocol MakeNicknameViewModelInput {
    func nicknameTextFieldDidChange(_ text: String?)
    func saveButtonDidTap()
}

protocol MakeNicknameViewModelOutput {
    var isSaveEnabled: Driver<Bool> { get }
    var isSucceedToSave: Driver<Result<String, AppError>> { get }
}

typealias MakeNicknameViewModel = MakeNicknameViewModelInput & MakeNicknameViewModelOutput
