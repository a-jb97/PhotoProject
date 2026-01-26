//
//  TopicViewController.swift
//  PhotoProject
//
//  Created by 전민돌 on 1/26/26.
//

import UIKit
import SnapKit

class TopicViewController: BaseViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "OUR TOPIC"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    override func configureHierarchy() {
        
    }
    
    override func configureLayout() {
        
    }
}
