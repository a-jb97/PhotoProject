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
    
    enum ColorFilter: String, CaseIterable {
        case black = "black"
        case white = "white"
        case blue = "blue"
        case yellow = "yellow"
        case orange = "orange"
        case red = "red"
        case purple = "purple"
        case magenta = "magenta"
        case green = "green"
        case teal = "teal"
        
        var uiColor: UIColor {
            switch self {
            case .black:
                    .black
            case .white:
                    .white
            case .blue:
                    .blue
            case .yellow:
                    .yellow
            case .orange:
                    .orange
            case .red:
                    .red
            case .purple:
                    .purple
            case .magenta:
                    .magenta
            case .green:
                    .green
            case .teal:
                    .systemTeal
            }
        }
        
        var label: String {
            switch self {
            case .black:
                "블랙"
            case .white:
                "화이트"
            case .blue:
                "블루"
            case .yellow:
                "옐로우"
            case .orange:
                "오렌지"
            case .red:
                "레드"
            case .purple:
                "퍼플"
            case .magenta:
                "마젠타"
            case .green:
                "그린"
            case .teal:
                "틸"
            }
        }
    }
    enum Sorted: String {
        case relevant = "relevant"
        case latest = "latest"
        
        var bool: Bool {
            switch self {
            case .relevant:
                false
            case .latest:
                true
            }
        }
    }
    
    var total = 0
    var searchedPhotos: [SearchDetail] = []
    var keyWord = ""
    var filter = "black_and_white"
    var sort = Sorted.relevant
    var page = 1
    var idIsLike: [String:Bool] = [:]
    
    let detailVC = DetailViewController()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        detailVC.detailLikeButtonAction = { [weak self] id, isLike in
            guard let self else { return }
            
            self.idIsLike[id] = isLike
        }
        
        searchedPhotoCollectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "SEARCH PHOTO"
        
        searchedPhotoCollectionView.isHidden = true
        statusLabel.isHidden = false
        sortButton.addTarget(self, action: #selector(toggleSortButton), for: .touchUpInside)
    }
    
    // MARK: 정렬 버튼 동작
    @objc private func toggleSortButton() {
        let cache = ImageCache.default
        
        cache.clearMemoryCache()
        cache.clearDiskCache()
        
        if sort == Sorted.latest {
            self.page = 1
            sort = Sorted.relevant
            sortButton.setTitle("관련순", for: .normal)
            
            NetworkManager.shared.callRequest(api: .search(query: keyWord, page: String(self.page), orderBy: self.sort.rawValue, color: self.filter), type: Search.self) { value in
                self.actionInNetWorkManager(value: value)

            } failure: { error in
                self.sort = Sorted.latest
                self.sortButton.setTitle("최신순", for: .normal)
                self.showAlert(message: error.description)
            }
            
        } else {
            self.page = 1
            sort = Sorted.latest
            sortButton.setTitle("최신순", for: .normal)
            
            NetworkManager.shared.callRequest(api: .search(query: keyWord, page: String(self.page), orderBy: self.sort.rawValue, color: self.filter), type: Search.self) { value in
                self.actionInNetWorkManager(value: value)

            } failure: { error in
                self.sort = Sorted.relevant
                self.sortButton.setTitle("관련순", for: .normal)
                self.showAlert(message: error.description)
            }
        }
    }
    
    private func actionInNetWorkManager(value: Search) {
        self.searchedPhotos = value.results
        
        if self.searchedPhotos.count != 0 {
            self.idIsLike = [:]
            
            for photo in self.searchedPhotos {
                self.idIsLike[photo.id] = false
            }
            
            self.statusLabel.isHidden = true
            self.searchedPhotoCollectionView.isHidden = false
            self.total = value.total
            self.searchedPhotoCollectionView.reloadData()
            self.searchedPhotoCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            
            print(self.idIsLike)
        } else {
            self.statusLabel.text = "검색 결과가 없어요."
            self.statusLabel.isHidden = false
            self.searchedPhotoCollectionView.isHidden = true
        }
    }
    
    override func configureHierarchy() {
        [keywordSearchBar, filterCollectionView, sortButton, statusLabel, searchedPhotoCollectionView].forEach { view.addSubview($0) }
    }
    
    override func configureLayout() {
        keywordSearchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        filterCollectionView.snp.makeConstraints { make in
            make.top.equalTo(keywordSearchBar.snp.bottom).offset(8)
            make.leading.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(32)
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
    enum TextValidationError: Error {
        case overThan10Text
        case resultIsEmpty
        case containsSpecialCharacter
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let cache = ImageCache.default
        
        cache.clearMemoryCache()
        cache.clearDiskCache()
        
        self.page = 1
        
        NetworkManager.shared.callRequest(api: .search(query: searchBar.text!, page: String(self.page), orderBy: self.sort.rawValue, color: self.filter), type: Search.self) { value in
            self.searchedPhotos = value.results
            self.total = value.total
            
            do {
                try self.validateSearchKeyword(data: self.searchedPhotos)
                
                self.idIsLike = [:]
                
                for photo in self.searchedPhotos {
                    self.idIsLike[photo.id] = false
                }
                
                self.keyWord = searchBar.text!
                self.statusLabel.isHidden = true
                self.searchedPhotoCollectionView.isHidden = false
                self.searchedPhotoCollectionView.reloadData()
                self.searchedPhotoCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
                
            } catch TextValidationError.overThan10Text {
                self.statusLabel.text = "10자 이하만 입력할 수 있어요."
                self.statusLabel.isHidden = false
                self.searchedPhotoCollectionView.isHidden = true
                
            } catch TextValidationError.containsSpecialCharacter {
                self.statusLabel.text = "특수문자는 입력할 수 없어요."
                self.statusLabel.isHidden = false
                self.searchedPhotoCollectionView.isHidden = true
                
            } catch TextValidationError.resultIsEmpty {
                self.statusLabel.text = "검색 결과가 없어요."
                self.statusLabel.isHidden = false
                self.searchedPhotoCollectionView.isHidden = true
                
            } catch {
                self.showAlert(message: "미확인 에러 발생")
            }
            
        } failure: { error in
            self.showAlert(message: error.description)
        }
        
        view.endEditing(true)
    }
    
    private func validateSearchKeyword(data: [SearchDetail]) throws {
        guard keywordSearchBar.text!.count <= 10 else {
            throw TextValidationError.overThan10Text
        }
        
        guard keywordSearchBar.text!.contains(try Regex("!@#$%^&*()-=+")) else {
            throw TextValidationError.containsSpecialCharacter
        }
        
        guard searchedPhotos.count != 0 else {
            throw TextValidationError.resultIsEmpty
        }
    }
}

extension SearchPhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == filterCollectionView {
            return ColorFilter.allCases.count
        } else {
            return searchedPhotos.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == filterCollectionView {
            let item = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionViewCell.identifier, for: indexPath) as! FilterCollectionViewCell
            
            item.colorImageView.backgroundColor = ColorFilter.allCases[indexPath.item].uiColor
            item.colorLabel.text = ColorFilter.allCases[indexPath.item].label
            
            if filter == ColorFilter.allCases[indexPath.item].rawValue {
                item.backgroundColor = .systemBlue
                item.colorLabel.textColor = .white
                item.layer.cornerRadius = item.frame.height / 2
            } else {
                item.backgroundColor = .systemGray6
                item.colorLabel.textColor = .black
                item.layer.cornerRadius = item.frame.height / 2
            }
            
            return item
        } else {
            let item = collectionView.dequeueReusableCell(withReuseIdentifier: SearchedPhotoCollectionViewCell.identifier, for: indexPath) as! SearchedPhotoCollectionViewCell
            let id = self.searchedPhotos[indexPath.item].id
            
            item.likeButtonAction = { [weak self] in
                guard let self else { return }
                
                self.idIsLike[id]?.toggle()
                self.searchedPhotoCollectionView.reloadItems(at: [indexPath])
            }
            
            item.photoImageView.kf.setImage(with: URL(string: searchedPhotos[indexPath.item].urls.small))
            item.starButton.setTitle(" \(String(searchedPhotos[indexPath.item].likes.formatted()))", for: .normal)
            
            if idIsLike[id] == true {
                item.likeButton.tintColor = .systemBlue
            } else {
                item.likeButton.tintColor = .white
            }
            
            return item
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == searchedPhotoCollectionView {
            if indexPath.item == (searchedPhotos.count - 1) && searchedPhotos.count <= self.total {
                self.page += 1
                
                NetworkManager.shared.callRequest(api: .search(query: keyWord, page: String(self.page), orderBy: self.sort.rawValue, color: self.filter), type: Search.self) { value in
                    self.searchedPhotos.append(contentsOf: value.results)
                    
                    for photo in self.searchedPhotos {
                        self.idIsLike[photo.id] = false
                    }
                    
                    self.searchedPhotoCollectionView.reloadData()
                    print(self.idIsLike)
                } failure: { error in
                    self.showAlert(message: error.description)
                }
            }
        }
        
        view.endEditing(true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == filterCollectionView {
            self.page = 1
            self.filter = ColorFilter.allCases[indexPath.item].rawValue
            
            collectionView.reloadData()
            
            NetworkManager.shared.callRequest(api: .search(query: self.keyWord, page: String(self.page), orderBy: self.sort.rawValue, color: ColorFilter.allCases[indexPath.item].rawValue), type: Search.self) { value in
                self.actionInNetWorkManager(value: value)
                
            } failure: { error in
                self.showAlert(message: error.description)
            }

        } else {
            let searchedData = searchedPhotos[indexPath.item]
            let date = DateFormat.shared.makeStringToDate(searchedData.created_at)
            let processor = DownsamplingImageProcessor(size: detailVC.photoImageView.bounds.size)
            
            detailVC.profileImageView.kf.setImage(with: URL(string: searchedData.user.profile_image.medium))
            detailVC.userNameLabel.text = searchedData.user.name
            detailVC.dateLabel.text = "\(DateFormat.shared.makeDateToString(date)) 게시됨"
            detailVC.likeButton.tintColor = .systemBlue
            detailVC.photoImageView.kf.setImage(
                with: URL(string: searchedData.urls.raw),
                options: [
                    .processor(processor)
                ]
            )
            detailVC.resolutionLabel.text = "\(searchedData.width) x \(searchedData.height)"
            
            detailVC.id = searchedData.id
            detailVC.isLike = idIsLike[searchedData.id]!
            
            if detailVC.isLike == true {
                detailVC.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            } else {
                detailVC.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            }
            
            NetworkManager.shared.callRequest(api: .statistics(photoID: searchedData.id), type: Statistics.self) { value in
                self.detailVC.viewsLabel.text = "\(value.views.total.formatted())"
                self.detailVC.downloadsLabel.text = "\(value.downloads.total.formatted())"
                self.detailVC.viewsData = value.views.historical.values
                self.detailVC.downloadData = value.downloads.historical.values
                
                self.navigationController?.pushViewController(self.detailVC, animated: true)
                
            } failure: { error in
                self.showAlert(message: error.description)
            }
        }
    }
}
