//
//  UIBezierPath+Polygon.swift
//  HiveMind
//
//  Created by Brian Hans on 4/19/17.
//  Copyright © 2017 BrianHans. All rights reserved.
//

import UIKit

extension UIBezierPath {
    
    static func roundedPolygonPath(rect: CGRect, lineWidth: CGFloat, sides: NSInteger, cornerRadius: CGFloat, rotationOffset: CGFloat = 0) -> UIBezierPath {
        let path = UIBezierPath()
        let theta: CGFloat = CGFloat(2.0 * .pi) / CGFloat(sides) // How much to turn at every corner
        let offset: CGFloat = cornerRadius * tan(theta / 2.0)     // Offset from which to start rounding corners
        let width = rect.size.height       // Width of the square
        
        let center = CGPoint(x: rect.origin.x + width / 2.0, y: rect.origin.y + width / 2.0)
        
        // Radius of the circle that encircles the polygon
        // Notice that the radius is adjusted for the corners, that way the largest outer
        // dimension of the resulting shape is always exactly the width - linewidth
        let radius = (width - lineWidth + cornerRadius - (cos(theta) * cornerRadius)) / 2.0
        
        // Start drawing at a point, which by default is at the right hand edge
        // but can be offset
        var angle = CGFloat(rotationOffset)
        
        
        let corner = CGPoint(x: center.x + (radius - cornerRadius) * cos(angle),y: center.y + (radius - cornerRadius) * sin(angle))
        path.move(to: CGPoint(x: corner.x + cornerRadius * cos(angle + theta),y: corner.y + cornerRadius * sin(angle + theta)))
        
        for _ in 0..<sides {
            angle += theta
            
            let corner = CGPoint(x: center.x + (radius - cornerRadius) * cos(angle), y: center.y + (radius - cornerRadius) * sin(angle))
            let start = CGPoint(x: corner.x + cornerRadius * cos(angle - theta),y: corner.y + cornerRadius * sin(angle - theta))
            let end = CGPoint(x:corner.x + cornerRadius * cos(angle + theta), y:corner.y + cornerRadius * sin(angle + theta))
            path.addLine(to: start)
            path.addLine(to: end)
        }
        
        path.close()
        
        // Move the path to the correct origins
        let bounds = path.bounds
        let transform = CGAffineTransform(translationX: -bounds.origin.x + rect.origin.x + lineWidth / 2.0, y: -bounds.origin.y + rect.origin.y + lineWidth / 2.0)
        path.apply(transform)
        
        return path
    }

    func rotateAroundCenter(radians: CGFloat) {
        let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY + 8)
        
        self.apply(CGAffineTransform(translationX: center.x, y: center.y).inverted())
        self.apply(CGAffineTransform(rotationAngle: radians))
        self.apply(CGAffineTransform(translationX: center.x, y: center.y))
        self.apply(CGAffineTransform(translationX: -15, y: 0))
    }
}

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi / 180 }
}
