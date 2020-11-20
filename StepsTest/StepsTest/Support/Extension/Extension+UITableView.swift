//
//  Extension+UITableView.swift
//  StepsTest
//
//  Created by Maksym Horbenko on 20.11.2020.
//

import UIKit

extension UITableView {
    func hasRow(at indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
}

extension UITableView {
    
    func registerNibForCell<T>(_ class: T.Type) {
        let className = String(describing: T.self)
        let nib = UINib(nibName: className, bundle: nil)
        register(nib, forCellReuseIdentifier: className)
    }
    
    func registerNibForHeader<T>(_ class: T.Type) {
        let className = String(describing: T.self)
        let nib = UINib(nibName: className, bundle: nil)
        register(nib, forHeaderFooterViewReuseIdentifier: className)
    }
    
    func dequeue <T: UITableViewCell & IdentifiedCell>(cell: T.Type) -> T {
        if let cell = self.dequeueReusableCell(withIdentifier: cell.identifier) as? T {
            return cell
        } else {
            self.register(cell.self, forCellReuseIdentifier: cell.identifier)
            return self.dequeueReusableCell(withIdentifier: cell.identifier) as! T
        }
    }
    
    func dequeueCell <T: UITableViewCell & IdentifiedCell>(cell: T.Type, configure: (T) -> Void) -> T {
        if let cell = self.dequeueReusableCell(withIdentifier: cell.identifier) as? T {
            configure(cell)
            return cell
        } else {
            self.register(T.self, forCellReuseIdentifier: T.identifier)
            return dequeueCell(cell: cell, configure: configure)
        }
    }
    
    func dequeueHeader <T: UITableViewHeaderFooterView & IdentifiedHeaderView>(header: T.Type, configure: (T) -> Void) -> T {
        if let header = self.dequeueReusableHeaderFooterView(withIdentifier: header.identifier) as? T {
            configure(header)
            return header
        } else {
            self.register(T.self, forHeaderFooterViewReuseIdentifier: T.identifier)
            return dequeueHeader(header: header, configure: configure)
        }
    }
}
