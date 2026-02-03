//
//  ProfileViewController.swift
//  PhotoProject
//
//  Created by 전민돌 on 2/3/26.
//

import UIKit
import SnapKit

final class ProfileViewController: BaseViewController {
    enum ValidationError: Error, LocalizedError {
        case isNotNumber
        case notRangeMonth
        case notRangeDay
        case containWhiteSpace
        
        var errorDescription: String? {
            switch self {
            case .isNotNumber:
                return "숫자만 입력할 수 있습니다."
            case .notRangeMonth:
                return "1 ~ 12 사이의 숫자만 입력할 수 있습니다."
            case .notRangeDay:
                return "1 ~ 31 사이의 숫자만 입력할 수 있습니다."
            case .containWhiteSpace:
                return "공백을 포함할 수 없습니다."
            }
        }
    }
    
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
    private let validationLabel = {
        let label = UILabel()
        
        label.font = .boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkButton.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
    }
    
    @objc private func checkButtonTapped() {
        do {
            try validateTextFieldInput(
                textList: [yearTextField.text!, monthTextField.text!, dayTextField.text!],
                textFields: [yearTextField, monthTextField, dayTextField]
            )
            
            validationLabel.text = "생년월일 기입이 성공했습니다."
        } catch ValidationError.isNotNumber {
            validationLabel.text = "숫자만 입력할 수 있습니다."
        } catch ValidationError.notRangeMonth {
            validationLabel.text = "'월'은 1 ~ 12 사이의 숫자만 입력할 수 있습니다."
        } catch ValidationError.notRangeDay {
            validationLabel.text = "'일'은1 ~ 31 사이의 숫자만 입력할 수 있습니다."
        } catch ValidationError.containWhiteSpace {
            validationLabel.text = "공백을 포함할 수 없습니다."
        } catch {
            validationLabel.text = ""
        }
    }
    
    private func validateTextFieldInput(textList: [String], textFields: [UITextField]) throws {
        for i in 0..<textFields.count {
            guard textList[i].contains(try Regex("[0-9]")) else {
                throw ValidationError.isNotNumber
            }
            
            if textFields[i] == monthTextField {
                guard (1...12).contains(Int(textList[i].replacingOccurrences(of: " ", with: "")) ?? 0) else {
                    throw ValidationError.notRangeMonth
                }
            }
            
            if textFields[i] == dayTextField {
                guard (1...31).contains(Int(textList[i].replacingOccurrences(of: " ", with: "")) ?? 0) else {
                    throw ValidationError.notRangeDay
                }
            }
            
            try textList[i].forEach { char in
                if char.isWhitespace {
                    throw ValidationError.containWhiteSpace
                }
            }
        }
    }
    
    override func configureHierarchy() {
        [yearTextField, monthTextField, dayTextField, checkButton, validationLabel].forEach { view.addSubview($0) }
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
        
        validationLabel.snp.makeConstraints { make in
            make.top.equalTo(checkButton.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(32)
        }
    }
}
