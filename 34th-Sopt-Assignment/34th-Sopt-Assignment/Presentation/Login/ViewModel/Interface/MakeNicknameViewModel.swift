//
//  MakeNicknameViewModel.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 5/29/24.
//

import RxSwift

protocol MakeNicknameViewModelInput {
    func nicknameTextFieldDidChange(_ text: String?)
    func saveButtonDidTap()
}

protocol MakeNicknameViewModelOutput {
    var isSaveEnabled: Observable<Bool> { get }
    var isSucceedToSave: Observable<Result<String, AppError>> { get }
}

typealias MakeNicknameViewModel = MakeNicknameViewModelInput & MakeNicknameViewModelOutput
