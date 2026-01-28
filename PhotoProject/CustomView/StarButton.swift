//
//  StarButton.swift
//  PhotoProject
//
//  Created by 전민돌 on 1/27/26.
//

import UIKit

class StarButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .zero)
        
        clipsToBounds = true
        layer.cornerRadius = 14
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        setImage(UIImage(systemName: "star.fill"), for: .normal)
        titleLabel?.font = .systemFont(ofSize: 12)
        tintColor = .systemYellow
        setTitleColor(.white, for: .normal)
        backgroundColor = .darkGray
    }
}
