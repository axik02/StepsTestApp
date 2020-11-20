//
//  ViewModel.swift
//  StepsTest
//
//  Created by Maksym Horbenko on 20.11.2020.
//

import Foundation

protocol ViewModel: class {
    associatedtype CoordinatorType

    var coordinator: CoordinatorType? { get set }
    
    func prepare()
}
