//
//  ObservablePattern.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 6/29/24.
//

import Foundation

final class ObservablePattern<T> {
    private(set) var value: T {
        didSet {
            listener?(value)
        }
    }
    
    private var listener: ((T) -> Void)?
    
    init(_ value: T) {
        self.value = value
    }
    
    func assign(_ value: T) {
        self.value = value
    }
    
    func bind(_ listener: @escaping (T) -> Void) {
        self.listener = listener
    }
    
    func bind<Object: AnyObject>(with object: Object, _ listener: @escaping (Object, T) -> Void) {
        self.listener = { [weak object] value in
            guard let object else { return }
            listener(object, value)
        }
    }
}
