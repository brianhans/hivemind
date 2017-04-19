//
//  SignalItemView.swift
//  HiveMind
//
//  Created by Brian Hans on 4/18/17.
//  Copyright © 2017 BrianHans. All rights reserved.
//

import UIKit

class SignalItemView: UIView {

    let colorButton: UIButton
    let signalTitleTextField: UITextField
    
    init(frame: CGRect, color: UIColor) {
        self.colorButton = UIButton(type: .custom)
        self.colorButton.backgroundColor = color
        self.signalTitleTextField = UITextField()
        
        super.init(frame: frame)
        setupViews()
        layoutIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Don't use storyboards please")
    }
    
    func setupViews() {
        self.colorButton.clipsToBounds = true
        self.signalTitleTextField.placeholder = "Set Option"
        
        self.addSubview(colorButton)
        self.addSubview(signalTitleTextField)
        
        colorButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.height.width.equalTo(50)
            make.centerY.equalToSuperview()
        }
        
        signalTitleTextField.snp.makeConstraints { (make) in
            make.left.equalTo(colorButton.snp.right).offset(20)
            make.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.height.equalTo(60)
        }
    }
    
    func setColor(_ color: UIColor) {
        self.colorButton.backgroundColor = color
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //Make color button a circle
        self.colorButton.layer.cornerRadius = self.colorButton.frame.width / 2
    }
}
