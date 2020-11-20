//
//  Coordinator.swift
//  StepsTest
//
//  Created by Maksym Horbenko on 20.11.2020.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    
    var parentCoordinator: Coordinator? { get set }
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController? { get set }
        
    func start()
}

extension Coordinator {
    
    func showError(_ error: NSError) {
        let action = UIAlertAction(title: "OK", style: .default)
        self.showAlert(title: "Error", subtitle: error.localizedDescription, alertStyle: .alert, actions: [action])
    }
    
    func showMessage(_ message: String) {
        let action = UIAlertAction(title: "OK", style: .default)
        self.showAlert(title: nil, subtitle: message, alertStyle: .alert, actions: [action])
    }
    
    func showAlert(title: String?, subtitle: String?, alertStyle: UIAlertController.Style = .alert, actions: [UIAlertAction] = [], animated: Bool = true) {
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: alertStyle)
        actions.forEach({ alert.addAction($0) })
        self.navigationController?.present(alert, animated: animated)
    }
    
    func returnToPrevious(animated: Bool = true, completion: (() -> Void)? = nil) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        navigationController?.popViewController(animated: animated)
        CATransaction.commit()
    }
    
    func returnToRoot(animated: Bool = true, completion: (() -> Void)? = nil) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        navigationController?.popToRootViewController(animated: animated)
        CATransaction.commit()
    }
    
    @discardableResult
    func removePreviousVC() -> Bool {
        guard
            let index = navigationController?.viewControllers.count,
            navigationController?.viewControllers.indices.contains(index - 2) ?? false
            else { return false }
        navigationController?.viewControllers.remove(at: index - 2)
        return true
    }
    
    @discardableResult
    func removeCurrentVC() -> Bool {
        guard
            let index = navigationController?.viewControllers.count,
            navigationController?.viewControllers.indices.contains(index - 1) ?? false
            else { return false }
        navigationController?.viewControllers.remove(at: index - 1)
        return true
    }
    
}
