//
//  TopicTableViewCell.swift
//  PhotoProject
//
//  Created by 전민돌 on 1/26/26.
//

import UIKit
import SnapKit

class TopicTableViewCell: BaseTableViewCell {
    lazy var topicCollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.register(TopicCollectionViewCell.self, forCellWithReuseIdentifier: TopicCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    let collectionViewLayout = {
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
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: TopicCollectionViewCell.identifier, for: indexPath) as! TopicCollectionViewCell
        
        
        
        return item
    }
}
