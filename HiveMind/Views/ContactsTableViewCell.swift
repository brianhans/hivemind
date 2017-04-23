//
//  ContactsTableViewCell.swift
//  HiveMind
//
//  Created by Brian Hans on 4/16/17.
//  Copyright © 2017 BrianHans. All rights reserved.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {

    lazy var nameLabel: UILabel = {
        var label = UILabel()
        return label
    }()
    
    lazy var checkBoxImage: UIImageView = {
        var imageView = UIImageView(image: #imageLiteral(resourceName: "Add"))
        imageView.tintColor = UIColor.goldenTainoi
        return imageView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func setupViews() {
        self.addSubview(nameLabel)
        self.addSubview(checkBoxImage)
        
        nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.right.equalTo(checkBoxImage.snp.left).offset(-10)
        }
        
        checkBoxImage.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(checkBoxImage.snp.width)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func setup(name: String) {
        self.nameLabel.text = name
    }
    
    func setChecked(_ checked: Bool, animated: Bool = true) {
        func check() {
            if checked {
                self.checkBoxImage.image = #imageLiteral(resourceName: "Checked")
                self.checkBoxImage.tintColor = UIColor.darkOrange
            } else {
                self.checkBoxImage.image =  #imageLiteral(resourceName: "Add")
                self.checkBoxImage.tintColor = UIColor.goldenTainoi
            }
        }
        
        if animated {
            UIView.animate(withDuration: 0.3) {
                check()
            }
        } else {
            check()
        }
    }
    
    override func prepareForReuse() {
        setChecked(false, animated: false)
    }
    
}
