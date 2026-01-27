//
//  FilterCollectionViewCell.swift
//  PhotoProject
//
//  Created by 전민돌 on 1/27/26.
//

import UIKit
import SnapKit

class FilterCollectionViewCell: BaseCollectionViewCell {
    let colorImageView = {
        let imageView = UIImageView()
        
        imageView.backgroundColor = .black
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        
        return imageView
    }()
    let colorLabel = {
        let label = UILabel()
        
        label.text = "블랙"
        
        return label
    }()
    
    override func configureHierarchy() {
        [colorImageView, colorLabel].forEach { contentView.addSubview($0) }
    }
    
    override func configureLayout() {
        colorImageView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView).offset(4)
            make.leading.equalTo(contentView).offset(4)
            make.height.width.equalTo(20)
        }
        
        colorLabel.snp.makeConstraints { make in
            make.centerY.equalTo(colorImageView)
            make.leading.equalTo(colorImageView.snp.trailing).offset(4)
        }
    }
    
    override func configureView() {
        contentView.backgroundColor = .lightGray
    }
}
