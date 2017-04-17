//
//  HiveUserCollectionViewCell.swift
//  HiveMind
//
//  Created by Brian Hans on 4/16/17.
//  Copyright © 2017 BrianHans. All rights reserved.
//

import UIKit

class HiveUserCollectionViewCell: UICollectionViewCell {
    
    lazy var titleLabel: UILabel = {
        var label = UILabel()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupViews() {
        self.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
        }
    }
    
    func setup(user: HiveUser, color: UIColor?) {
        self.titleLabel.text = user.name
        self.backgroundColor = color ?? .white
    }
}
