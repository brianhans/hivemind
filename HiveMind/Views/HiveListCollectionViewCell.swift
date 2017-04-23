//
//  HiveListTableViewCell.swift
//  HiveMind
//
//  Created by Brian Hans on 4/16/17.
//  Copyright © 2017 BrianHans. All rights reserved.
//

import UIKit

class HiveListCollectionViewCell: UICollectionViewCell {
    
    lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.textColor = UIColor.white
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
        
        self.layer.cornerRadius = 10
    }

    func setup(hive: Hive) {
        self.titleLabel.text = hive.name
        self.titleLabel.font = UIFont(name: "Avenir", size: 36)

        self.backgroundColor = UIColor.darkOrange
    }
    
    func setupFirst(){
        self.titleLabel.text = "+ New Hive"
        self.backgroundColor = UIColor.blue
    }
    
   
    // sets height cell to fit content
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        super.preferredLayoutAttributesFitting(layoutAttributes)
        
        
        let attr = layoutAttributes.copy() as! UICollectionViewLayoutAttributes
        
        let desiredHeight = self.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        
        attr.size.height = desiredHeight
        attr.size.width = UIScreen.main.bounds.width
        
        return attr
    }
    
}
