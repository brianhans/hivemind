//
//  SignalViewController.swift
//  HiveMind
//
//  Created by Brian Hans on 4/18/17.
//  Copyright © 2017 BrianHans. All rights reserved.
//

import UIKit

class SignalViewController: UIViewController {

    lazy var navigationBar: UINavigationBar = {
        let bar = UINavigationBar()
        return bar
    }()
    
    lazy var cancelButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(close))
        return button
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("Send", for: .normal)
        button.backgroundColor = UIColor.blue
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        return button
    }()
    
    lazy var signalItemStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()
    
    lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor.clear
        textField.font = UIFont.systemFont(ofSize: 40)
        textField.placeholder = "Enter title"
        return textField
    }()
    
    var contentView: UIView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    func setupViews() {
        self.navigationItem.title = "New Signal"
        self.navigationItem.rightBarButtonItem = cancelButton
        self.view.backgroundColor = UIColor.white
        
        let signalItem = SignalItemView(frame: .zero, color: .blue)
        
        navigationBar.pushItem(self.navigationItem, animated: false)
        
        self.view.addSubview(navigationBar)
        self.view.addSubview(contentView)
        self.contentView.addSubview(sendButton)
        self.contentView.addSubview(titleTextField)
        self.contentView.addSubview(signalItemStackView)
        signalItemStackView.addArrangedSubview(signalItem)
        
        navigationBar.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(64)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.top.equalTo(navigationBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        titleTextField.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(100)
        }
        
        signalItemStackView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(50)
            make.right.equalToSuperview().offset(-50)
            make.top.equalTo(titleTextField.snp.bottom).offset(20)
            make.bottom.equalTo(sendButton.snp.top).offset(20)
        }
        
        sendButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.left.equalToSuperview().offset(50)
            make.right.equalToSuperview().offset(-50)
            make.bottom.equalToSuperview().offset(-50)
        }
    }
    
    func close() {
        self.dismiss(animated: true, completion: nil)
    }
}
