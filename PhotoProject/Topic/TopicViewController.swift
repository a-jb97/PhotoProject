//
//  TopicViewController.swift
//  PhotoProject
//
//  Created by 전민돌 on 1/26/26.
//

import UIKit
import SnapKit

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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
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
        
        return cell
    }
}
