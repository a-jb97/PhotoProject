//
//  LikeButton.swift
//  PhotoProject
//
//  Created by 전민돌 on 1/30/26.
//

import UIKit

class LikeButton: UIButton {
    var isLike = false
    
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
        layer.backgroundColor = UIColor.white.cgColor.copy(alpha: 0.5)
        setImage(UIImage(systemName: "heart.fill"), for: .normal)
        
        if isLike {
            tintColor = .systemBlue
        } else {
            tintColor = .white
        }
    }
}
