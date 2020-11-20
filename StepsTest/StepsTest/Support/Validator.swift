//
//  Validator.swift
//  Zipclippin
//
//  Created by useradmin on 3/10/20.
//  Copyright © 2020 Codesque. All rights reserved.
//

import UIKit

class Validator {
    
    // MARK: - Bounds validation
    
    func isValid(lowerBound: Int?, upperBound: Int?) -> Bool {
        do {
            try validate(lowerBound: lowerBound, upperBound: upperBound)
            return true
        } catch {
            return false
        }
    }
    
    func validate(lowerBound: Int?, upperBound: Int?) throws {
        guard
            let lowerBound = lowerBound,
            let upperBound = upperBound
            else { throw ErrorHelper.shared.error("Invalid Bounds") }
        if lowerBound < 1 {
            throw ErrorHelper.shared.error("Lower bound must not be less than 1")
        }
        if upperBound < 1 {
            throw ErrorHelper.shared.error("Upper bound must not be less than 1")
        }
        if lowerBound >= upperBound {
            throw ErrorHelper.shared.error("Upper bound must be less(or equal) than Lower bound")
        }
    }
    
}
