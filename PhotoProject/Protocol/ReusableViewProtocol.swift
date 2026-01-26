//
//  ReusableViewProtocol.swift
//  PhotoProject
//
//  Created by 전민돌 on 1/26/26.
//

import UIKit

protocol ReusableViewProtocol {
    static var identifier: String { get }
}

extension BaseViewController: ReusableViewProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}

extension BaseTableViewCell: ReusableViewProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}

extension BaseCollectionViewCell: ReusableViewProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}
