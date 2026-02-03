//
//  TopicViewController.swift
//  PhotoProject
//
//  Created by 전민돌 on 1/26/26.
//

import UIKit
import SnapKit
import Kingfisher

class TopicViewController: BaseViewController {
    let profileButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "person.fill"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.clipsToBounds = true
        button.layer.cornerRadius = 20
        
        return button
    }()
    
    let titleLabel = {
        let label = UILabel()
        
        label.text = "OUR TOPIC"
        label.font = .systemFont(ofSize: 35, weight: UIFont.Weight(rawValue: 0.5))
        
        return label
    }()
    
    lazy var topicTableView = {
        let tableView = UITableView()
        let screenHeight = UIScreen.main.bounds.height
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = screenHeight / 3.6
        tableView.separatorStyle = .none
        
        tableView.register(TopicTableViewCell.self, forCellReuseIdentifier: TopicTableViewCell.identifier)
        
        return tableView
    }()
    
    lazy var randomTopics = shuffleTopic()
    var topicsPhotos: [[Topic]] = Array(repeating: [], count: 3)
    
    private var lastRequestTime: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networking(topicIDs: randomTopics)
        
        configureRefreshControl()
        
        profileButton.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
    }
    
    @objc private func profileButtonTapped() {
        let vc = ProfileViewController()
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func shuffleTopic() -> [TopicID] {
        let shuffledTopics = TopicID.allCases.shuffled()
        var pickTopics: [TopicID] = []
        
        for topic in shuffledTopics {
            pickTopics.append(topic)
        }
        
        return pickTopics
    }
    
    // MARK: 당겨서 새로고침
    @objc private func actionRefreshControl() {
        let limitInterval: TimeInterval = 60
        
        if let lastTime = lastRequestTime, Date().timeIntervalSince(lastTime) < limitInterval {
            self.topicTableView.refreshControl?.endRefreshing()
            
            return
        }
        
        randomTopics = shuffleTopic()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.networking(topicIDs: self.randomTopics)
            self.topicTableView.refreshControl?.endRefreshing()
            self.topicTableView.reloadData()
        }
        
        self.lastRequestTime = Date()
    }
    
    private func configureRefreshControl() {
        topicTableView.refreshControl = UIRefreshControl()
        topicTableView.refreshControl?.addTarget(self, action: #selector(actionRefreshControl), for: .valueChanged)
    }
    
    // MARK: 네트워크 통신
    private func networking(topicIDs: [TopicID]) {
        let cache = ImageCache.default
        
        cache.clearMemoryCache()
        cache.clearDiskCache()
        
        let group = DispatchGroup()
        
        for topicID in 0...2 {
            group.enter()
            DispatchQueue.global().async(group: group) {
                NetworkManager.shared.callRequest(api: .topic(topicID: topicIDs[topicID]), type: [Topic].self) { response in
                    switch response {
                    case .success(let value):
                        self.topicsPhotos[topicID] = value
                        
                        print("\(topicID) 성공")
                        
                        group.leave()
                    case .failure(let error):
                        self.showAlert(message: error.description)
                        
                        print("\(topicID) 실패")
                        
                        group.leave()
                    }
                }
            }
        }
        
        group.notify(queue: .main) {
            self.topicTableView.reloadData()
            print("END")
        }
    }
    
    override func configureHierarchy() {
        view.addSubview(profileButton)
        view.addSubview(titleLabel)
        view.addSubview(topicTableView)
    }
    
    override func configureLayout() {
        profileButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(-28)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.width.height.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(profileButton.snp.bottom)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
        
        topicTableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.horizontalEdges.equalTo(view)
            make.bottom.equalTo(view)
        }
    }
}

extension TopicViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return randomTopics[section].description
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TopicTableViewCell.identifier, for: indexPath) as! TopicTableViewCell
        
        cell.topicPhotos = self.topicsPhotos[indexPath.section]
        cell.topicCollectionView.reloadData()
        
        cell.selectItem = { [weak self] topic in
            guard let self else { return }
            
            let vc = DetailViewController()
            let date = DateFormat.shared.makeStringToDate(topic.created_at)
            
            vc.profileImageView.kf.setImage(with: URL(string: topic.user.profile_image.medium))
            vc.userNameLabel.text = topic.user.name
            vc.dateLabel.text = "\(DateFormat.shared.makeDateToString(date)) 게시됨"
            vc.photoImageView.kf.setImage(with: URL(string: topic.urls.raw))
            vc.resolutionLabel.text = "\(topic.width) x \(topic.height)"
            
            NetworkManager.shared.callRequest(api: .statistics(photoID: topic.id), type: Statistics.self) { response in
                switch response {
                case .success(let value):
                    vc.viewsLabel.text = "\(value.views.total.formatted())"
                    vc.downloadsLabel.text = "\(value.downloads.total.formatted())"
                    vc.viewsData = value.views.historical.values
                    vc.downloadData = value.downloads.historical.values
                case .failure(let error):
                    self.showAlert(message: error.description)
                }
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        return cell
    }
}
