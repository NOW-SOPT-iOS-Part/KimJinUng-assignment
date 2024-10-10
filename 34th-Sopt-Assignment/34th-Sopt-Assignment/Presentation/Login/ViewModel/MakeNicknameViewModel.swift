//
//  MakeNicknameViewModel.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 5/26/24.
//

import RxSwift
import RxCocoa

final class MakeNicknameViewModel: ViewModelType {
    struct Input {
        let nicknameTextFieldDidChange: Observable<String?>
        let saveButtonDidTap: Observable<Void>
    }
    
    struct Output {
        let isSaveEnabled: Driver<Bool>
        let isSucceedToSave: Driver<Result<String, AppError>>
    }
    
    func transform(from input: Input, with disposeBag: DisposeBag) -> Output {
        let isSaveEnabled = input.nicknameTextFieldDidChange
            .map { value in
                guard let nickname = value,
                      !nickname.isEmpty
                else {
                    return false
                }
                return true
            }
            .asDriver(onErrorJustReturn: false)
        
        let isSucceedToSave = input.saveButtonDidTap
            .withLatestFrom(input.nicknameTextFieldDidChange)
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
        
        let output = Output(
            isSaveEnabled: isSaveEnabled,
            isSucceedToSave: isSucceedToSave
        )
        
        return output
    }
}

extension MakeNicknameViewModel: RegexCheckable {}
