//
//  MakeNicknameViewModel.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 5/26/24.
//

import RxSwift
import RxRelay

final class MakeNicknameViewModel: ViewModelType, RegexCheckable {
    struct Input {
        let nicknameTextFieldDidChange: Observable<String?>
        let saveButtonDidTap: Observable<Void>
    }
    
    struct Output {
        let isSaveEnabled: Observable<Bool>
        let isSucceedToSave: Observable<String>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let isSaveEnabled = input.nicknameTextFieldDidChange.map { value in
            guard let nickname = value,
                  !nickname.isEmpty
            else {
                return false
            }
            return true
        }
        
        let isSucceedToSave = input.saveButtonDidTap
            .withLatestFrom(input.nicknameTextFieldDidChange)
            .flatMap { [weak self] nickname -> Observable<String> in
                guard let self,
                      let nickname
                else {
                    return .error(AppError.unknown)
                }
                
                if !checkFrom(input: nickname, regex: .nickname) {
                    return .error(AppError.nickname)
                }
                
                return .just(nickname)
            }
        
        let output = Output(
            isSaveEnabled: isSaveEnabled,
            isSucceedToSave: isSucceedToSave
        )
        return output
    }
}
