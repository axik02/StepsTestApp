//
//  AppCoordinator.swift
//  StepsTest
//
//  Created by Maksym Horbenko on 20.11.2020.
//

import UIKit

protocol CoordinatorLogoutDelegate: class {
    func onLogout()
}

final class AppCoordinator: NSObject, Coordinator {
    
    var parentCoordinator: Coordinator? = nil
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController?
    
    private let networkManager: NetworkManager

    required init(navigationController: UINavigationController?, networkManager: NetworkManager) {
        self.navigationController = navigationController
        self.networkManager = networkManager
    }
    
    func start() {
        let viewModel = FieldInputViewModel(coordinator: self)
        let vc = FieldInputViewController(viewModel: viewModel)
        navigationController?.delegate = self
        navigationController?.setViewControllers([vc], animated: false)
    }
    
    enum Segues {
//        case fieldInputViewController
        case commentsViewController(bounds: Bounds)
    }
    
    func show(segue: Segues, animated: Bool = true) {
        let vc:UIViewController

        switch segue {
//        case .fieldInputViewController:
//            vc = createFieldInputViewController()
        case .commentsViewController(let bounds):
            vc = createCommentsViewController(bounds: bounds)
        }
        navigationController?.pushViewController(vc, animated: animated)
    }
    
    private func createFieldInputViewController() -> UIViewController {
        let viewModel = FieldInputViewModel(coordinator: self)
        let vc = FieldInputViewController(viewModel: viewModel)
        return vc
    }
    
    private func createCommentsViewController(bounds: Bounds) -> UIViewController {
        let viewModel = CommentsViewModel(coordinator: self, networkManager: networkManager, bounds: bounds)
        let vc = CommentsViewController(viewModel: viewModel)
        return vc
    }
    
    private func remove(_ child: Coordinator?) {
        for (index,coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
}

extension AppCoordinator: CoordinatorLogoutDelegate {
    
    func onLogout() {
        self.navigationController?.presentedViewController?.dismiss(animated: true)
        self.navigationController?.viewControllers.forEach { $0.navigationController?.popViewController(animated: true) }
        self.childCoordinators.forEach { $0.navigationController?.viewControllers.forEach({ $0.navigationController?.popViewController(animated: true) }) }
        self.childCoordinators.forEach { remove($0) }
        self.start()
    }
    
}

extension AppCoordinator: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        // Read the view controller we’re moving from.
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        
        // Check whether our view controller array already contains that view controller. If it does it means we’re pushing a different view controller on top rather than popping it, so exit.
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
        
        //        // We’re still here – it means we’re popping the view controller, so we can check whether it’s a buy view controller
        //        if let testSplitViewController = fromViewController as? TestSplitViewController {
        //            // We're popping a buy view controller; end its coordinator
        //            remove(testSplitViewController.viewModel.coordinator)
        //        }
        
    }
    
}


