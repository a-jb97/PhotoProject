//
//  SearchedPhotoCollectionViewCell.swift
//  PhotoProject
//
//  Created by 전민돌 on 1/27/26.
//

import UIKit
import SnapKit

class SearchedPhotoCollectionViewCell: BaseCollectionViewCell {
    let photoImageView = {
        let imageView = UIImageView()
        
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        imageView.backgroundColor = .systemBrown
        
        return imageView
    }()
    let starButton = StarButton()
    
    override func configureHierarchy() {
        [photoImageView, starButton].forEach { contentView.addSubview($0) }
    }
    
    override func configureLayout() {
        photoImageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        
        starButton.snp.makeConstraints { make in
            make.leading.equalTo(photoImageView).offset(8)
            make.bottom.equalTo(photoImageView.snp.bottom).inset(8)
            make.height.equalTo(28)
        }
    }
}
