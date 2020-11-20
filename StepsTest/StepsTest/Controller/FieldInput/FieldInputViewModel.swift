//
//  FieldInputViewModel.swift
//  StepsTest
//
//  Created by Maksym Horbenko on 20.11.2020.
//

import Foundation
import RxSwift

class FieldInputViewModel: ViewModel {
    
    weak var coordinator: AppCoordinator?
    
    let lowerBound = BehaviorSubject<String>(value: "")
    let upperBound = BehaviorSubject<String>(value: "")

    let isDoneActive: Observable<Bool>

    required init(coordinator: AppCoordinator?) {
        self.coordinator = coordinator
        self.isDoneActive = Observable.combineLatest(self.lowerBound, self.upperBound).map({ (lowerBound, upperBound) in
            let validator = Validator()
            return validator.isValid(lowerBound: Int(lowerBound), upperBound: Int(upperBound))
        })
    }
    
    func prepare() { }
    
    func onDone() {
        guard
            let lower = try? lowerBound.value(),
            let upper = try? upperBound.value(),
            let intLower = Int(lower),
            let intUpper = Int(upper)
        else { return }
        let bounds = Bounds(lower: intLower, upper: intUpper)
        coordinator?.show(segue: .commentsViewController(bounds: bounds))
    }
    
}
