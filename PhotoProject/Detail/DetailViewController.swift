//
//  DetailViewController.swift
//  PhotoProject
//
//  Created by 전민돌 on 1/26/26.
//

import UIKit
import SnapKit
import Kingfisher
import SwiftUI

class DetailViewController: BaseViewController {
    let scrollView = UIScrollView()
    let contentView = UIView()
    
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
    let likeButton = LikeButton()
    
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
    
    let chartTitleLabel = {
        let label = UILabel()
        
        label.text = "차트"
        label.font = .boldSystemFont(ofSize: 17)
        
        return label
    }()
    lazy var chartSeg = {
        let seg = UISegmentedControl(items: ["조회", "다운로드"])
        
        seg.selectedSegmentIndex = 0
        seg.addTarget(self, action: #selector(segValueChanged), for: .valueChanged)
        
        return seg
    }()
    
    var viewsData: [ValuesDetail] = []
    var downloadData: [ValuesDetail] = []
    
    @available(iOS 16, *)
    lazy var hostingController = UIHostingController(rootView: ChartView(viewsData: viewsData))
    
    var id = ""
    var isLike = false
    var detailLikeButtonAction: ((String, Bool) -> Void)?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        scrollView.setContentOffset(CGPoint(x: 0, y: -scrollView.adjustedContentInset.top), animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        likeButton.addTarget(self, action: #selector(detailLikeButtonTapped), for: .touchUpInside)
        
        configureContentView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateViewsChart(data: viewsData)
    }
    
    @objc private func detailLikeButtonTapped() {
        isLike.toggle()
        
        if isLike == true {
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        
        detailLikeButtonAction?(id, isLike)
        print("\(id), \(isLike)")
    }
    
    @objc private func segValueChanged() {
        let selectedSeg = chartSeg.selectedSegmentIndex
        
        if selectedSeg == 0 {
            updateViewsChart(data: viewsData)
        } else if selectedSeg == 1 {
            updateDownloadChart(data: downloadData)
        }
    }
    
    func updateViewsChart(data: [ValuesDetail]) {
        viewsData = data
        hostingController.rootView = ChartView(viewsData: viewsData)
    }
    
    func updateDownloadChart(data: [ValuesDetail]) {
        downloadData = data
        hostingController.rootView = ChartView(viewsData: downloadData)
    }
    
    override func configureHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
    }
    
    override func configureLayout() {
        scrollView.backgroundColor = .white
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.backgroundColor = .white
        contentView.snp.makeConstraints { make in
            make.width.equalTo(scrollView.snp.width)
            make.verticalEdges.equalTo(scrollView)
        }
    }
    
    private func configureContentView() {
        addChild(hostingController)
        
        [profileImageView, userNameLabel, dateLabel, likeButton, photoImageView, informationLabel, resolutionTitleLabel, resolutionLabel, viewsTitleLabel, viewsLabel, downloadsTitleLabel, downloadsLabel, chartTitleLabel, chartSeg, hostingController.view].forEach { contentView.addSubview($0) }
        
        hostingController.didMove(toParent: self)
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(16)
            make.leading.equalTo(contentView).offset(16)
            make.height.width.equalTo(40)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(18)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(4)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
        }
        
        likeButton.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView)
            make.trailing.equalTo(contentView).inset(16)
            make.height.width.equalTo(28)
        }
        
        photoImageView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(contentView)
            make.height.lessThanOrEqualTo(400)
        }
        
        informationLabel.snp.makeConstraints { make in
            make.top.equalTo(photoImageView.snp.bottom).offset(16)
            make.leading.equalTo(contentView).offset(16)
        }
        
        resolutionTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(photoImageView.snp.bottom).offset(20)
            make.leading.equalTo(contentView).offset(100)
        }
        
        resolutionLabel.snp.makeConstraints { make in
            make.centerY.equalTo(resolutionTitleLabel)
            make.trailing.equalTo(contentView).inset(16)
        }
        
        viewsTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(resolutionTitleLabel.snp.bottom).offset(16)
            make.leading.equalTo(contentView).offset(100)
        }
        
        viewsLabel.snp.makeConstraints { make in
            make.centerY.equalTo(viewsTitleLabel)
            make.trailing.equalTo(contentView).inset(16)
        }
        
        downloadsTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(viewsTitleLabel.snp.bottom).offset(16)
            make.leading.equalTo(contentView).offset(100)
        }
        
        downloadsLabel.snp.makeConstraints { make in
            make.centerY.equalTo(downloadsTitleLabel)
            make.trailing.equalTo(contentView).inset(16)
        }
        
        chartTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(informationLabel.snp.bottom).offset(100)
            make.leading.equalTo(contentView).offset(16)
        }
        
        chartSeg.snp.makeConstraints { make in
            make.top.equalTo(informationLabel.snp.bottom).offset(100)
            make.leading.equalTo(contentView).offset(100)
        }
        
        hostingController.view.snp.makeConstraints { make in
            make.top.equalTo(chartSeg.snp.bottom).offset(16)
            make.leading.equalTo(contentView).offset(100)
            make.trailing.equalTo(contentView).inset(16)
            make.bottom.equalTo(contentView).inset(16)
        }
    }
}
