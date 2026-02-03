//
//  TopicTableViewCell.swift
//  PhotoProject
//
//  Created by 전민돌 on 1/26/26.
//

import UIKit
import SnapKit
import Kingfisher

class TopicTableViewCell: BaseTableViewCell {
    lazy var topicCollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.register(TopicCollectionViewCell.self, forCellWithReuseIdentifier: TopicCollectionViewCell.identifier)
        
        return collectionView
    }()
    private let collectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        
        let inset: CGFloat = 16
        let spacing: CGFloat = 8
        let screenWidth = UIScreen.main.bounds.width
        
        let totalInset = inset * 2
        let itemWidth = (screenWidth - totalInset - spacing) / 2
        
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.3)
        
        return layout
    }()
    
    var topicPhotos: [Topic] = []
    var selectItem: ((Topic) -> Void)?
    
    override func configureHierarchy() {
        contentView.addSubview(topicCollectionView)
    }
    
    override func configureLayout() {
        topicCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
}

extension TopicTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topicPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: TopicCollectionViewCell.identifier, for: indexPath) as! TopicCollectionViewCell
        
        item.topicImageView.kf.setImage(with: URL(string: topicPhotos[indexPath.item].urls.small))
        item.starButton.setTitle(" \(topicPhotos[indexPath.item].likes.formatted())", for: .normal)
        
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let topicsData = topicPhotos[indexPath.item]
        
        selectItem?(topicsData)
    }
}
