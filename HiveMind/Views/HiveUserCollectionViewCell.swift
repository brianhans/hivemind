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
    
    override func layoutSubviews() {
        let lineWidth = CGFloat(1)
        
        //        let path = roundedPolygonPath(rect: self.frame, lineWidth: lineWidth, sides: sides, cornerRadius: 15.0, rotationOffset: CGFloat(.pi / 2.0))
        let path = UIBezierPath.roundedPolygonPath(rect: self.bounds, lineWidth: 1, sides: 6, cornerRadius: 0)
        path.rotateAroundCenter(radians: CGFloat(90.degreesToRadians))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        
//        let borderLayer = CAShapeLayer()
//        borderLayer.frame = self.bounds
//        borderLayer.path = path.cgPath
//        borderLayer.lineWidth = lineWidth
//        //        borderLayer.lineJoin = kCALineJoinRound
//        //        borderLayer.lineCap = kCALineCapRound
//        borderLayer.strokeColor = UIColor.black.cgColor
//        borderLayer.fillColor = UIColor.white.cgColor
//        
//        self.layer.addSublayer(borderLayer)
    }
    

}
