//
//  StarButton.swift
//  PhotoProject
//
//  Created by 전민돌 on 1/27/26.
//

import UIKit

extension UIButton {
    static let starButton = {
        let button = UIButton()
        
        button.clipsToBounds = true
        button.layer.cornerRadius = 14
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        button.setImage(UIImage(systemName: "star.fill"), for: .normal)
        button.setTitle("123,456", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.tintColor = .systemYellow
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .darkGray
        
        return button
    }()
}
