//
//  ProfileTextField.swift
//  PhotoProject
//
//  Created by 전민돌 on 2/3/26.
//

import UIKit

final class ProfileTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(placeHolder: String) {
        super.init(frame: .zero)
        
        clipsToBounds = true
        layer.cornerRadius = 15
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemBlue.cgColor
        placeholder = placeHolder
    }
}
