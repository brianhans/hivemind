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
        textField.tintColor = UIColor.white
        textField.textColor = UIColor.white
        return textField
    }()
    
    lazy var exitButton: UIButton = {
        let button = UIButton(type: .custom)
        let imageView = UIImageView(image: #imageLiteral(resourceName: "close"))
        imageView.tintColor = .darkOrange
        imageView.contentMode = .scaleAspectFit
        button.addSubview(imageView)
        button.tintColor = UIColor.darkOrange
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(close), for: .touchUpInside)
        
        imageView.snp.makeConstraints({ (make) in
            make.top.left.equalToSuperview().offset(5)
            make.right.bottom.equalToSuperview().offset(-5)
        })
        
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont(name: ".SFUIText-Heavy", size: 24)

        label.text = "Name the Hive"
        return label
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(addHive), for: .touchUpInside)
        button.setTitle("Add", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: button.titleLabel?.font.pointSize ?? 12)
        return button
    }()
    
    lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkOrange
        return view
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
        inputField.becomeFirstResponder()
    }
    
    func setupViews() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(close))
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.tintColor = UIColor.darkOrange
        
        self.view.addSubview(backgroundView)
        
        backgroundView.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalTo(150)
        }
        
        let topView = UIView()
        
        backgroundView.addSubview(topView)
        backgroundView.addSubview(bottomView)
        bottomView.addSubview(addButton)
        bottomView.addSubview(inputField)
        
        backgroundView.addSubview(exitButton)
        topView.addSubview(titleLabel)
        
        topView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top)
        }
        
        exitButton.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(10)
            make.height.width.equalTo(30)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        inputField.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalTo(addButton.snp.left).offset(-10)
            make.top.bottom.equalToSuperview()
        }
        
        addButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.3)
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
