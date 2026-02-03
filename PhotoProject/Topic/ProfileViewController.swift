//
//  ProfileViewController.swift
//  PhotoProject
//
//  Created by 전민돌 on 2/3/26.
//

import UIKit
import SnapKit

final class ProfileViewController: BaseViewController {
    private let yearTextField = ProfileTextField(placeHolder: "연도를 입력해주세요")
    private let monthTextField = ProfileTextField(placeHolder: "월을 입력해주세요")
    private let dayTextField = ProfileTextField(placeHolder: "일을 입력해주세요")
    private let checkButton = {
        let button = UIButton()
        
        button.backgroundColor = .systemBlue
        button.setTitle("확인", for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 15
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkButton.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
    }
    
    @objc private func checkButtonTapped() {
        
    }
    
    override func configureHierarchy() {
        [yearTextField, monthTextField, dayTextField, checkButton].forEach { view.addSubview($0) }
    }
    
    override func configureLayout() {
        dayTextField.snp.makeConstraints { make in
            make.center.equalTo(view)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(32)
            make.height.equalTo(52)
        }
        
        monthTextField.snp.makeConstraints { make in
            make.bottom.equalTo(dayTextField.snp.top).offset(-16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(32)
            make.height.equalTo(52)
        }
        
        yearTextField.snp.makeConstraints { make in
            make.bottom.equalTo(monthTextField.snp.top).offset(-16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(32)
            make.height.equalTo(52)
        }
        
        checkButton.snp.makeConstraints { make in
            make.top.equalTo(dayTextField.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(32)
            make.height.equalTo(56)
        }
    }
}
