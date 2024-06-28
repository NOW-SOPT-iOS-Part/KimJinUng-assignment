//
//  DefaultMakeNicknameViewModel.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 5/26/24.
//

import RxSwift
import RxCocoa

final class DefaultMakeNicknameViewModel {
    
    // MARK: - Input Relay

    private let nicknameTextFieldRelay = PublishRelay<String?>()
    private let saveButtonRelay = PublishRelay<Void>()
}

extension DefaultMakeNicknameViewModel: MakeNicknameViewModel {
    
    // MARK: - Output
    
    var isSaveEnabled: Driver<Bool> {
        nicknameTextFieldRelay.map { value in
            guard let nickname = value,
                  !nickname.isEmpty
            else {
                return false
            }
            return true
        }
        .asDriver(onErrorJustReturn: false)
    }
    
    var isSucceedToSave: Driver<Result<String, AppError>> {
        saveButtonRelay
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
            .asDriver(onErrorJustReturn: .failure(.unknown))
    }
    
    // MARK: - Input
    
    func nicknameTextFieldDidChange(_ text: String?) {
        nicknameTextFieldRelay.accept(text)
    }
    
    func saveButtonDidTap() {
        saveButtonRelay.accept(())
    }
}

extension DefaultMakeNicknameViewModel: RegexCheckable {}
