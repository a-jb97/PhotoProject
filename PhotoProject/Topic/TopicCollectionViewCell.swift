//
//  TopicCollectionViewCell.swift
//  PhotoProject
//
//  Created by 전민돌 on 1/26/26.
//

import UIKit
import SnapKit

class TopicCollectionViewCell: BaseCollectionViewCell {
    let topicImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        
        imageView.backgroundColor = .systemBrown
        
        return imageView
    }()
    let starButton = StarButton()
    
    override func configureHierarchy() {
        contentView.addSubview(topicImageView)
        contentView.addSubview(starButton)
    }
    
    override func configureLayout() {
        topicImageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        
        starButton.snp.makeConstraints { make in
            make.leading.equalTo(topicImageView).offset(8)
            make.bottom.equalTo(topicImageView).inset(8)
            make.height.equalTo(28)
        }
    }
}
