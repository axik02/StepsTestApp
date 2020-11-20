//
//  SplashViewModel.swift
//  StepsTest
//
//  Created by Maksym Horbenko on 20.11.2020.
//

import Foundation

class SplashViewModel: ViewModel {
    
    weak var coordinator: AppCoordinator?
    
    required init(coordinator: AppCoordinator?) {
        self.coordinator = coordinator
    }
    
    func prepare() {
        
    }
    
}
