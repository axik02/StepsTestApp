//
//  IdentifiedCell&IdentifiedHeaderView.swift
//  StepsTest
//
//  Created by Maksym Horbenko on 20.11.2020.
//

import Foundation

protocol IdentifiedCell {
    static var identifier: String { get }
}

extension IdentifiedCell {
    static var identifier: String {
        return String(describing: self)
    }
}

protocol IdentifiedHeaderView {
    static var identifier: String { get }
}

extension IdentifiedHeaderView {
    static var identifier: String {
        return String(describing: self)
    }
}
