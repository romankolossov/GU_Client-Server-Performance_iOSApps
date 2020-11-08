//
//  GradientView.swift
//  vkAlissia
//
//  Created by Роман Колосов on 12.07.2020.
//  Copyright © 2020 Roman N. Kolosov. All rights reserved.
//

import UIKit

class GradientView: UIView {
    @IBInspectable var startColor: UIColor = UIColor.gradientStartColor {
        didSet {
            self.updateColors()
        }
    }
    @IBInspectable var endColor: UIColor = UIColor.gradientEndColor {
        didSet {
            self.updateColors()
        }
    }
    @IBInspectable var startLocation: CGFloat = 0 {
        didSet {
            self.updateLocations()
        }
    }
    @IBInspectable var endLocation: CGFloat = 1 {
        didSet {
            self.updateLocations()
        }
    }
    @IBInspectable var startPoint: CGPoint = .zero {
        didSet {
            self.updateStartPoint()
        }
    }
    @IBInspectable var endPoint: CGPoint = CGPoint(x: 0, y: 1) {
        didSet {
            self.updateEndPoint()
        }
    }
    
    override static var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    var gradientLayer: CAGradientLayer {
        return self.layer as! CAGradientLayer
    }
    
    func updateLocations() {
        self.gradientLayer.locations = [self.startLocation as NSNumber, self.endLocation as NSNumber]
    }
    
    func updateColors() {
        self.gradientLayer.colors = [self.startColor.cgColor, self.endColor.cgColor]
    }
    
    func updateStartPoint() {
        self.gradientLayer.startPoint = startPoint
    }
    
    func updateEndPoint() {
        self.gradientLayer.endPoint = endPoint
    }
}
