//
//  SignalViewController.swift
//  HiveMind
//
//  Created by Brian Hans on 4/18/17.
//  Copyright © 2017 BrianHans. All rights reserved.
//

import UIKit

class SignalViewController: UIViewController {

    var colors: [UIColor] = [.brightGreen, .goldenTainoi, .dullRed]
    
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
        button.addTarget(self, action: #selector(sendSignal), for: .touchUpInside)
        button.setTitle("Send", for: .normal)
        button.backgroundColor = UIColor.blue
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        return button
    }()
    
    lazy var signalItemStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        return stack
    }()
    
    lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor.clear
        textField.font = UIFont.systemFont(ofSize: 40)
        textField.placeholder = "Enter title"
        return textField
    }()
    
    lazy var addField: UIButton = {
        let view = UIButton()
        view.addTarget(self, action: #selector(addInputField), for: .touchUpInside)
        view.backgroundColor = .clear
        view.setTitleColor(.black, for: .normal)
        view.setTitle("+ Add Field", for: .normal)
        
        return view
    }()
    
    var contentView: UIView = UIView()
    var completion: ((String, [String]) -> Void)?
    
    init(completion: @escaping (String, [String]) -> Void) {
        self.completion = completion
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    func setupViews() {
        self.navigationItem.title = "New Signal"
        self.navigationItem.rightBarButtonItem = cancelButton
        self.view.backgroundColor = UIColor.white
        
        let signalItem = SignalItemView(frame: .zero, color: colors[0])
        
        navigationBar.pushItem(self.navigationItem, animated: false)
        
        self.view.addSubview(navigationBar)
        self.view.addSubview(contentView)
        self.contentView.addSubview(sendButton)
        self.contentView.addSubview(titleTextField)
        self.contentView.addSubview(signalItemStackView)
        signalItemStackView.addArrangedSubview(signalItem)
        signalItem.colorButton.addTarget(self, action: #selector(showColorPicker), for: .touchUpInside)
        signalItemStackView.addArrangedSubview(addField)
        
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
            make.height.equalTo(180 + (15 * 3))
        }
        
        sendButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.left.equalToSuperview().offset(50)
            make.right.equalToSuperview().offset(-50)
            make.bottom.equalToSuperview().offset(-50)
        }
    }
    
    func sendSignal() {
        var options: [String] = []
        var colors: [UIColor] = []
        for item in signalItemStackView.arrangedSubviews {
            if let signialItem = item as? SignalItemView, let option = signialItem.signalTitleTextField.text {
                options.append(option)
                colors.append(signialItem.colorButton.backgroundColor!)
            }
        }
        
        //TODO: Send to server
        
    }
    
    func addInputField() {
        let signalItem = SignalItemView(frame: .zero, color: colors[signalItemStackView.arrangedSubviews.count - 1])
        signalItem.colorButton.addTarget(self, action: #selector(showColorPicker), for: .touchUpInside)
        signalItemStackView.insertArrangedSubview(signalItem, at: signalItemStackView.arrangedSubviews.count - 1)
        
        //Remove the add button if they reach the max amount
        if signalItemStackView.arrangedSubviews.count > 3 {
            addField.removeFromSuperview()
        }
    }
    
    func showColorPicker(sender: UIButton) {
        let colorPickerController = ColorPickerController { (color) in
            sender.backgroundColor = color
        }
        
        colorPickerController.modalPresentationStyle = .overCurrentContext
        colorPickerController.modalTransitionStyle = .crossDissolve
        self.present(colorPickerController, animated: true, completion: nil)
    }
    
    func close() {
        self.dismiss(animated: true, completion: nil)
    }
}
