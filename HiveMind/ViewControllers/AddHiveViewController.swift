//
//  AddHiveViewController.swift
//  HiveMind
//
//  Created by Brian Hans on 4/16/17.
//  Copyright © 2017 BrianHans. All rights reserved.
//

import UIKit

protocol AddHiveDelegate: class {
    func hiveCreated(hive: Hive)
}

class AddHiveViewController: UIViewController {
    
    weak var delegate: AddHiveDelegate?
    
    lazy var inputField: UITextField = {
        let textField = UIPaddedTextField()
        textField.layer.borderWidth = 1.5
        textField.layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
        textField.layer.cornerRadius = 5
        
        return textField
    }()
    
    lazy var exitButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "close"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.tintColor = UIColor.blue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(close), for: .touchUpInside)
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "Name the Hive"
        return label
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.blue, for: .normal)
        button.addTarget(self, action: #selector(addHive), for: .touchUpInside)
        button.setTitle("Add", for: .normal)
        return button
    }()
    
    lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        return view
    }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    func setupViews() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(close))
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
                
        self.view.addSubview(backgroundView)
        
        backgroundView.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
        }
        
        backgroundView.addSubview(exitButton)
        backgroundView.addSubview(inputField)
        backgroundView.addSubview(addButton)
        backgroundView.addSubview(titleLabel)
        
        exitButton.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(10)
            make.bottom.equalTo(titleLabel.snp.bottom)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(exitButton.snp.top)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        inputField.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(30)
        }
        
        addButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(inputField.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func addHive() {
        guard let text = inputField.text, !text.isEmpty else { return }
        
        //TODO: Acutally make the call to the server
        delegate?.hiveCreated(hive: Hive(id: text, name: text, users: []))
        
        self.close()
    }
    
    func close() {
        UIView.animate(withDuration: 0.5, animations: { 
            self.view.alpha = 0
        }) { _ in
            self.dismiss(animated: false, completion: nil)
        }
    }
}

extension AddHiveViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }
}
