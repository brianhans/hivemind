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
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 50)
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
            make.centerY.equalToSuperview().offset(-10)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview()
        }
    }
    
    func setup(user: HiveUser, color: UIColor?) {
        let initials = user.name.components(separatedBy: " ").map{$0.substring(to: $0.index($0.startIndex, offsetBy: 1))}.joined()
        self.titleLabel.text = initials
        self.backgroundColor = color ?? .white
    }
    
    func setupFirst(){
        self.titleLabel.text = "+"
        self.backgroundColor = .darkOrange
    }
    
    override func layoutSubviews() {
        let path = UIBezierPath.roundedPolygonPath(rect: self.bounds, lineWidth: 1, sides: 6, cornerRadius: 0)
        path.rotateAroundCenter(radians: CGFloat(90.degreesToRadians))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    

}
