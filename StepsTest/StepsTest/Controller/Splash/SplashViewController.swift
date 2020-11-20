//
//  SplashViewController.swift
//  StepsTest
//
//  Created by Maksym Horbenko on 20.11.2020.
//

import UIKit

class SplashViewController: UIViewController {
    
    let viewModel: SplashViewModel
    
    init(viewModel: SplashViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.prepare()
    }
    
}
