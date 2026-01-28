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
            make.verticalEdges.equalTo(contentView).inset(3)
            make.leading.equalTo(contentView).offset(2)
            make.height.width.equalTo(contentView.frame.height * 0.8)
        }
        
        colorLabel.snp.makeConstraints { make in
            make.centerY.equalTo(colorImageView)
            make.leading.equalTo(colorImageView.snp.trailing).offset(8)
        }
    }
    
    override func configureView() {
        contentView.backgroundColor = .lightGray
        contentView.layer.cornerRadius = contentView.frame.height / 2
        colorImageView.layer.cornerRadius = (contentView.frame.height * 0.8) / 2
    }
}
