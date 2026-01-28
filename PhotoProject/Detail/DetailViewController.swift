//
//  DetailViewController.swift
//  PhotoProject
//
//  Created by 전민돌 on 1/26/26.
//

import UIKit
import SnapKit
import Kingfisher

class DetailViewController: BaseViewController {
    let profileImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .lightGray
        imageView.image = UIImage(systemName: "person.fill")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        
        return imageView
    }()
    let userNameLabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 12)
        
        return label
    }()
    let dateLabel = {
        let label = UILabel()
        
        label.font = .boldSystemFont(ofSize: 12)
        
        return label
    }()
    let heartButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        
        return button
    }()
    
    let photoImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    let informationLabel = {
        let label = UILabel()
        
        label.text = "정보"
        label.font = .boldSystemFont(ofSize: 17)
        
        return label
    }()
    
    let resolutionTitleLabel = {
        let label = UILabel()
        
        label.text = "크기"
        label.font = .boldSystemFont(ofSize: 14)
        
        return label
    }()
    let resolutionLabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 12)
        
        label.text = "3840 x 2160"
        
        return label
    }()
    
    let viewsTitleLabel = {
        let label = UILabel()
        
        label.text = "조회수"
        label.font = .boldSystemFont(ofSize: 14)
        
        return label
    }()
    let viewsLabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 12)
        
        return label
    }()
    
    let downloadsTitleLabel = {
        let label = UILabel()
        
        label.text = "다운로드"
        label.font = .boldSystemFont(ofSize: 14)
        
        return label
    }()
    let downloadsLabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 12)
        
        return label
    }()
    
    override func configureHierarchy() {
        [profileImageView, userNameLabel, dateLabel, heartButton, photoImageView, informationLabel, resolutionTitleLabel, resolutionLabel, viewsTitleLabel, viewsLabel, downloadsTitleLabel, downloadsLabel].forEach { view.addSubview($0) }
    }
    
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.height.width.equalTo(40)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(18)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(4)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
        }
        
        heartButton.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        photoImageView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(view)
            make.height.lessThanOrEqualTo(300)
        }
        
        informationLabel.snp.makeConstraints { make in
            make.top.equalTo(photoImageView.snp.bottom).offset(16)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
        
        resolutionTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(photoImageView.snp.bottom).offset(20)
            make.leading.equalTo(view.safeAreaInsets).offset(100)
        }
        
        resolutionLabel.snp.makeConstraints { make in
            make.centerY.equalTo(resolutionTitleLabel)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        viewsTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(resolutionTitleLabel.snp.bottom).offset(16)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(100)
        }
        
        viewsLabel.snp.makeConstraints { make in
            make.centerY.equalTo(viewsTitleLabel)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        downloadsTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(viewsTitleLabel.snp.bottom).offset(16)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(100)
        }
        
        downloadsLabel.snp.makeConstraints { make in
            make.centerY.equalTo(downloadsTitleLabel)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
}
