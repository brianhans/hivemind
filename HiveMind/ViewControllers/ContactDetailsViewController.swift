//
//  ContactDetailsViewController.swift
//  HiveMind
//
//  Created by Nabil K on 2017-04-23.
//  Copyright © 2017 BrianHans. All rights reserved.
//

import UIKit

class ContactDetailsViewController: UIViewController {

    //TODO: abstract into a viewModel
    
    var user: HiveUser
    var signal: Signal?

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
    
    lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        return view
    }()
    

    lazy var nameLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont(name: ".SFUIText-Heavy", size: 24)
        
        label.text = "Name the Hive"
        return label
    }()
    
    lazy var latestResponseHeaderLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .left
        label.font = UIFont(name: ".SFUIText-Heavy", size: 12)
        label.text = "Latest Response"
        return label
    }()
    
    
    lazy var latestResponseLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .left
        label.font = UIFont(name: ".SFUIText-Heavy", size: 14)
        label.text = "No Response"
        label.numberOfLines = 3
        return label
    }()
    
    lazy var callButton: UIButton = {
        let button = UIButton(type: .custom)
        let imageView = UIImageView(image: #imageLiteral(resourceName: "phone"))
        imageView.contentMode = .scaleAspectFit
        button.addSubview(imageView)
        button.translatesAutoresizingMaskIntoConstraints = false
        //TODO: Add a target
        
        imageView.snp.makeConstraints({ (make) in
            make.top.left.equalToSuperview().offset(5)
            make.right.bottom.equalToSuperview().offset(-5)
        })
        
        return button
        
    }()
    
    lazy var textButton: UIButton = {
        let button = UIButton(type: .custom)
        let imageView = UIImageView(image: #imageLiteral(resourceName: "text-bubble"))
        imageView.contentMode = .scaleAspectFit
        button.addSubview(imageView)
        button.translatesAutoresizingMaskIntoConstraints = false
        //TODO: Add a target
        
        imageView.snp.makeConstraints({ (make) in
            make.top.left.equalToSuperview().offset(5)
            make.right.bottom.equalToSuperview().offset(-5)
        })
        
        return button
    
    }()
    
    init(signal: Signal?, user: HiveUser) {
        self.user = user
        self.signal = signal
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(close))
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
        
        view.addSubview(backgroundView)
        backgroundView.addSubview(nameLabel)
        backgroundView.addSubview(exitButton)
        backgroundView.addSubview(latestResponseHeaderLabel)
        backgroundView.addSubview(latestResponseLabel)
        backgroundView.addSubview(callButton)
        backgroundView.addSubview(textButton)
        
        
        
        backgroundView.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(200)
        }
        
        
    
        exitButton.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(10)
            make.height.width.equalTo(30)
        }
        
        nameLabel.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview()
        }
        
        latestResponseHeaderLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview()
        }
        
        latestResponseLabel.snp.makeConstraints { (make) in
        make.top.equalTo(latestResponseHeaderLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview()
        }
        
        callButton.snp.makeConstraints{ (make) in
            make.top.equalTo(latestResponseHeaderLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(8)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        textButton.snp.makeConstraints { (make) in
            make.top.equalTo(latestResponseHeaderLabel.snp.bottom).offset(8)
            make.left.equalTo(callButton.snp.right).offset(4)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
    }
    
    func populateLabels(){
        self.nameLabel.text = user.name
        
        if let signal = signal, user.status > 0 && user.status < signal.options.count {
            self.latestResponseLabel.text = signal.options[user.status - 1]
        } else {
            self.latestResponseLabel.text = ""
        }
    }
    
    func close() {
        UIView.animate(withDuration: 0.5, animations: {
            self.view.alpha = 0
        }) { _ in
            self.dismiss(animated: false, completion: nil)
        }
    }
}


extension ContactDetailsViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        populateLabels()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


extension ContactDetailsViewController:UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }
}

