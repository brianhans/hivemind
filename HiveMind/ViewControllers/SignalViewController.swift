//
//  SignalViewController.swift
//  HiveMind
//
//  Created by Brian Hans on 4/18/17.
//  Copyright © 2017 BrianHans. All rights reserved.
//

import UIKit

class SignalViewController: UIViewController {

    var colors: [UIColor] = [.brightGreen, .dullRed, .craterBrown]
    var maxCharacters = 130
    
    lazy var navigationBar: UINavigationBar = {
        let bar = UINavigationBar()
        return bar
    }()
    
    lazy var signalItemStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        return stack
    }()
    
    lazy var titleTextField: UITextView = {
        let textField = UITextView()
        textField.backgroundColor = UIColor.clear
        textField.font = UIFont(name: ".SFUIText-Heavy", size: 40)!
        textField.delegate = self
        textField.text = "Enter Title"
        textField.textColor = UIColor.lightGray
        return textField
    }()
    
    lazy var cancelButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(close))
        return button
    }()
    
    lazy var sendlButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Send", style: .done, target: self, action: #selector(sendSignal))
        return button
    }()
    
    lazy var addField: SignalItemView = {
        let view = SignalItemView(frame: .zero, color: .lightGray)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addInputField))
        view.addGestureRecognizer(tapGesture)
        view.signalTitleTextField.isUserInteractionEnabled = false
        view.signalTitleTextField.placeholder = "Add Option"
        // TODO: verify this functionality
        view.signalTitleTextField.delegate = self
        view.setTextFieldDelegate(delegate: self)
        let plusImage = UIImageView(image: #imageLiteral(resourceName: "Plus"))
        plusImage.contentMode = .scaleAspectFit
        


        view.colorButton.addSubview(plusImage)
        
        plusImage.snp.makeConstraints({ (make) in
            make.top.left.equalToSuperview().offset(20)
            make.right.bottom.equalToSuperview().offset(-20)
        })
        
        return view
    }()
    
    var contentView: UIView = UIView()
    var completion: ((Signal) -> Void)?
    
    init(completion: @escaping (Signal) -> Void) {
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
        self.navigationItem.title = ""
        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationItem.rightBarButtonItem = sendlButton
        
        self.view.backgroundColor = UIColor.white
        
        let signalItem = SignalItemView(frame: .zero, color: colors[0])
        signalItem.setTextFieldDelegate(delegate: self)
        
        navigationBar.backgroundColor = UIColor.clear
        navigationBar.isTranslucent = true
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.tintColor = UIColor.darkOrange
        
        navigationBar.pushItem(self.navigationItem, animated: false)
        
        self.view.addSubview(navigationBar)
        self.view.addSubview(contentView)
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
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview()
            make.top.equalTo(navigationBar.snp.bottom).offset(20)
            make.bottom.equalTo(signalItemStackView.snp.top).offset(-20)
        }
        
        signalItemStackView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(50)
            make.right.equalToSuperview().offset(-50)
            make.centerY.equalToSuperview()
            make.height.equalTo(180 + (25 * 3))
        }
    }
    
    func sendSignal() {
        var options: [String] = []
        var colors: [UIColor] = []
        for item in signalItemStackView.arrangedSubviews {
            if let signialItem = item as? SignalItemView, let option = signialItem.signalTitleTextField.text, !option.isEmpty {
                options.append(option)
                colors.append(signialItem.colorButton.backgroundColor!)
            }
        }
        
        if let title = titleTextField.text, !title.isEmpty {
            let newSignal = Signal(title: title, options: options, statusColors: colors)
            completion?(newSignal)
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    func addInputField() {
        let signalItem = SignalItemView(frame: .zero, color: colors[signalItemStackView.arrangedSubviews.count - 1])
        signalItem.setTextFieldDelegate(delegate: self)
        
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

extension SignalViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter Title"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "" && text.characters.count == 0 {
            print("case 1")
            maxCharacters += (range.length + 1)
            return true
        }
        
        else if maxCharacters - range.length > 1 {
            maxCharacters -= (range.length + 1)
            return true
        }
        
        return false
        
    }
}

extension SignalViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == "" && string.characters.count == 0 {
            print("case 1")
            maxCharacters += (range.length)
            return true
        }
            
        else if maxCharacters - range.length > 1 {
            maxCharacters -= (range.length + 1)
            return true
        }
        
        return false
    }
    
    
}
