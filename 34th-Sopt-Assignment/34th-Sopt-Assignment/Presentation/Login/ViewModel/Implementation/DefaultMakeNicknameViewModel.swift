//
//  DefaultMakeNicknameViewModel.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 5/26/24.
//

import RxSwift
import RxRelay

final class DefaultMakeNicknameViewModel {
    
    // MARK: - Input Relay

    private let nicknameTextFieldRelay = PublishRelay<String?>()
    private let saveButtonRelay = PublishRelay<Void>()
}

extension DefaultMakeNicknameViewModel: MakeNicknameViewModel {
    
    // MARK: - Output
    
    var isSaveEnabled: Observable<Bool> { setIsSaveEnabled() }
    var isSucceedToSave: Observable<Result<String, AppError>> { setIsSucceedToSave() }
    
    // MARK: - Input
    
    func nicknameTextFieldDidChange(_ text: String?) {
        nicknameTextFieldRelay.accept(text)
    }
    
    func saveButtonDidTap() {
        saveButtonRelay.accept(())
    }
}

extension DefaultMakeNicknameViewModel: RegexCheckable {
    private func setIsSaveEnabled() -> Observable<Bool> {
        return nicknameTextFieldRelay.map { value in
            guard let nickname = value,
                  !nickname.isEmpty
            else {
                return false
            }
            return true
        }
    }
    
    private func setIsSucceedToSave() -> Observable<Result<String, AppError>> {
        return saveButtonRelay
            .withLatestFrom(nicknameTextFieldRelay)
            .flatMap { [weak self] nickname -> Observable<Result<String, AppError>> in
                guard let self,
                      let nickname
                else {
                    return .just(.failure(.unknown))
                }
                
                if !checkFrom(input: nickname, regex: .nickname) {
                    return .just(.failure(.nickname))
                }
                
                return .just(.success(nickname))
            }
    }
}
