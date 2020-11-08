//
//  StarView.swift
//  vkAlissia
//
//  Created by Роман Колосов on 08.08.2020.
//  Copyright © 2020 Roman N. Kolosov. All rights reserved.
//

import UIKit

@IBDesignable class StarView : UIView {
    override class var layerClass: AnyClass{
        return CAShapeLayer.self
    }
    
    private let path = UIBezierPath()
    
    var shapeLayer : CAShapeLayer {
        return (layer as! CAShapeLayer)
    }
    
    func configure() {
        backgroundColor = .starBacgroundColor
        
        path.move(to: CGPoint(x: 40, y: 20))
        path.addLine(to: CGPoint(x: 45, y: 40))
        path.addLine(to: CGPoint(x: 65, y: 40))
        path.addLine(to: CGPoint(x: 50, y: 50))
        path.addLine(to: CGPoint(x: 60, y: 70))
        path.addLine(to: CGPoint(x: 40, y: 55))
        path.addLine(to: CGPoint(x: 20, y: 70))
        path.addLine(to: CGPoint(x: 30, y: 50))
        path.addLine(to: CGPoint(x: 15, y: 40))
        path.addLine(to: CGPoint(x: 35, y: 40))
        path.close()
        
        shapeLayer.path = path.cgPath
        
        shapeLayer.fillColor = UIColor.starFillColor.cgColor
        shapeLayer.strokeColor = UIColor.starStrokeColor.cgColor
    }
    
    func animate() {
        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimation.fromValue = 0
        strokeStartAnimation.toValue = 1
        
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = 0
        strokeEndAnimation.toValue = 1.3
        
        let animationGroup = CAAnimationGroup()
        
        animationGroup.duration = 2.2
        animationGroup.beginTime = CACurrentMediaTime() + 0.2
        animationGroup.animations = [strokeStartAnimation, strokeEndAnimation]
        layer.add(animationGroup, forKey: nil)
        
        configure()
    }
}
