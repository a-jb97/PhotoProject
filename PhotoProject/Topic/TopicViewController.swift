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
    
    let randomTopics = {
        let shuffledTopics = TopicID.allCases.shuffled()
        var pickTopics: [TopicID] = []
        
        for topic in shuffledTopics {
            pickTopics.append(topic)
        }
        
        return pickTopics
    }()
    
    override func configureHierarchy() {
        view.addSubview(titleLabel)
        view.addSubview(topicTableView)
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
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
        
        NetworkManager.shared.callRequest(api: .topic(topicID: randomTopics[indexPath.section]), type: [Topic].self) { value in
            cell.topicPhotos = value
            cell.topicCollectionView.reloadData()
        } failure: { error in
            print(error.description)
        }
        
        cell.selectItem = { [weak self] topic in
            guard let self else { return }
            
            let vc = DetailViewController()
            let date = DateFormat.shared.makeStringToDate(topic.created_at)
            
            vc.profileImageView.kf.setImage(with: URL(string: topic.user.profile_image.medium))
            vc.userNameLabel.text = topic.user.name
            vc.dateLabel.text = "\(DateFormat.shared.makeDateToString(date)) 게시됨"
            vc.photoImageView.kf.setImage(with: URL(string: topic.urls.raw))
            vc.resolutionLabel.text = "\(topic.width) x \(topic.height)"
            
            NetworkManager.shared.callRequest(api: .statistics(photoID: topic.id), type: Statistics.self) { value in
                vc.viewsLabel.text = "\(value.views.total.formatted())"
                vc.downloadsLabel.text = "\(value.downloads.total.formatted())"
            } failure: { error in
                print(error.description)
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        return cell
    }
}
