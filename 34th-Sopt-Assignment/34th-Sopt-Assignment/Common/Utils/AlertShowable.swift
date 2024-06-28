//
//  AlertShowable.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 4/18/24.
//

import UIKit

protocol AlertShowable {
    func showAlert(title: String, message: String)
}

extension AlertShowable where Self: UIViewController {
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let confirmAction = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(confirmAction)
        present(alertController, animated: true)
    }
}
