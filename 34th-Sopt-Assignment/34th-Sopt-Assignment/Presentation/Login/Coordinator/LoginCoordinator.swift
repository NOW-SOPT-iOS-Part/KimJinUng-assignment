//
//  LoginCoordinator.swift
//  34th-Sopt-Assignment
//
//  Created by 김진웅 on 6/2/24.
//

import UIKit

final class LoginCoordinator: Coordinator {
    let navigationController: UINavigationController
    
    weak var parentCoordinator: AppCoordinator?
    
    var childCoordinators = [Coordinator]()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        start()
    }
    
    func start() {
        showLogin()
    }
}

extension LoginCoordinator {
    func moveToNickname(delegate: MakeNicknameViewDelegate?) {
        let viewController = MakeNicknameViewController(
            delegate: delegate, viewModel: DefaultMakeNicknameViewModel()
        )
        viewController.modalPresentationStyle = .formSheet
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 24
        }
        navigationController.present(viewController, animated: true)
    }
    
    func moveToWelcome(id: String, nickname: String?) {
        let viewController = WelcomeViewController(id: id, nickname: nickname)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func moveToMain() {
        parentCoordinator?.didFinish(self)
        parentCoordinator?.isLoginSucceed = true
    }
}

private extension LoginCoordinator {
    func showLogin() {
        let viewModel = DefaultLoginViewModel()
        let viewController = LoginViewController(viewModel: viewModel)
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: false)
    }
}
