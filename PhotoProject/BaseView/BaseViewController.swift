//
//  BaseViewController.swift
//  PhotoProject
//
//  Created by 전민돌 on 1/26/26.
//

import UIKit

class BaseViewController: UIViewController, ViewDesignProtocol {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    func configureHierarchy() {
        
    }
    
    func configureLayout() {
        
    }
    
    func configureView() {
        view.backgroundColor = .white
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
