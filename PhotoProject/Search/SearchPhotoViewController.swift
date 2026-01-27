//
//  SearchPhotoViewController.swift
//  PhotoProject
//
//  Created by 전민돌 on 1/26/26.
//

import UIKit
import SnapKit
import Kingfisher

class SearchPhotoViewController: BaseViewController {
    lazy var keywordSearchBar = {
        let searchBar = UISearchBar()
        
        searchBar.delegate = self
        searchBar.placeholder = "키워드 검색"
        
        return searchBar
    }()
    lazy var filterCollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: filterCollectionViewLayout)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.register(FilterCollectionViewCell.self, forCellWithReuseIdentifier: FilterCollectionViewCell.identifier)
        
        return collectionView
    }()
    let sortButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "line.3.horizontal.decrease"), for: .normal)
        button.setTitle("관련순", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.setTitleColor(.black, for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.backgroundColor = .white
        button.tintColor = .black
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 16)
        
        return button
    }()
    let statusLabel = {
        let label = UILabel()
        
        label.text = "사진을 검색해보세요."
        label.font = .boldSystemFont(ofSize: 17)
        
        return label
    }()
    lazy var searchedPhotoCollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: searchedPhotoCollectionViewLayout)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(SearchedPhotoCollectionViewCell.self, forCellWithReuseIdentifier: SearchedPhotoCollectionViewCell.identifier)
        
        return collectionView
    }()
    let filterCollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        
        let inset: CGFloat = 4
        let spacing: CGFloat = 8
        let screenWidth = UIScreen.main.bounds.width
        
        let totalInset = inset * 2
        let itemWidth = (screenWidth - totalInset - spacing) / 4.5
        
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.itemSize = CGSize(width: itemWidth, height: 30)
        
        return layout
    }()
    let searchedPhotoCollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        
        let inset: CGFloat = 2
        let spacing: CGFloat = 4
        let screenWidth = UIScreen.main.bounds.width
        
        let totalInset = inset * 2
        let itemWidth = (screenWidth - totalInset - spacing) / 2
        
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: inset, left: 0, bottom: inset, right: 0)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.4)
        
        return layout
    }()
    
    var searchedPhotos: Search = Search(results: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchedPhotoCollectionView.isHidden = true
        statusLabel.isHidden = false
    }
    
    override func configureHierarchy() {
        [keywordSearchBar, filterCollectionView, sortButton, statusLabel, searchedPhotoCollectionView].forEach { view.addSubview($0) }
    }
    
    override func configureLayout() {
        keywordSearchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        filterCollectionView.snp.makeConstraints { make in
            make.top.equalTo(keywordSearchBar.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(30)
        }
        
        sortButton.snp.makeConstraints { make in
            make.centerY.equalTo(filterCollectionView)
            make.trailing.equalTo(view).offset(10)
            make.height.equalTo(30)
        }
        
        searchedPhotoCollectionView.snp.makeConstraints { make in
            make.top.equalTo(filterCollectionView.snp.bottom).offset(8)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.center.equalTo(searchedPhotoCollectionView)
        }
    }
}

extension SearchPhotoViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        NetworkManager.shared.callRequest(api: .search(query: searchBar.text!, page: "1", orderBy: "latest", color: "blue"), type: Search.self) { value in
            self.searchedPhotos = value
            
            if self.searchedPhotos.results.count != 0 {
                self.statusLabel.isHidden = true
                self.searchedPhotoCollectionView.isHidden = false
                
                self.searchedPhotoCollectionView.reloadData()
            } else {
                self.statusLabel.text = "검색 결과가 없습니다"
                self.statusLabel.isHidden = false
                self.searchedPhotoCollectionView.isHidden = true
            }
        } failure: { error in
            print(error.description)
        }
    }
}

extension SearchPhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == filterCollectionView {
            return 11
        } else {
            return searchedPhotos.results.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == filterCollectionView {
            let item = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionViewCell.identifier, for: indexPath) as! FilterCollectionViewCell
            
            return item
        } else {
            let item = collectionView.dequeueReusableCell(withReuseIdentifier: SearchedPhotoCollectionViewCell.identifier, for: indexPath) as! SearchedPhotoCollectionViewCell
            
            item.photoImageView.kf.setImage(with: URL(string: searchedPhotos.results[indexPath.item].urls.small))
            item.starButton.setTitle(" \(String(searchedPhotos.results[indexPath.item].likes.formatted()))", for: .normal)
            
            return item
        }
    }
}
