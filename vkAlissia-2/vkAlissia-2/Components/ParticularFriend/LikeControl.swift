//
//  LikeControl.swift
//  vkAlissia
//
//  Created by Роман Колосов on 18.07.2020.
//  Copyright © 2020 Roman N. Kolosov. All rights reserved.
//

import UIKit

class LikeControl: UIControl {
    private var count: Int = 0
    
    private let countLabel = UILabel()
    private let imageView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(countLabel)
        addSubview(imageView)
        
        let imageConstraints = [
            imageView.leftAnchor.constraint(equalTo: leftAnchor),
            imageView.rightAnchor.constraint(equalTo: countLabel.leftAnchor),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 20),
            imageView.heightAnchor.constraint(equalTo: heightAnchor)
        ]
        
        let labelConstraint = [
            countLabel.rightAnchor.constraint(equalTo: rightAnchor),
            countLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(labelConstraint + imageConstraints)
        
        imageView.isUserInteractionEnabled = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onHeartTapped(_:)))
        imageView.addGestureRecognizer(gesture)
        updateView()
    }
    
    private func updateView() {
        countLabel.text = "\(count)"
        if isSelected {
            imageView.image = UIImage(systemName: "heart.fill")
        } else {
            imageView.image = UIImage(systemName: "heart")
        }
    }
    
    @objc func onHeartTapped(_ gesture: UIGestureRecognizer) {
        isSelected = !isSelected
        animateImageView()
        count += isSelected ? 1 : -1
        updateView()
        sendActions(for: .valueChanged)
    }
    
    func animateImageView() {
        let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.fromValue = 0
        animation.toValue = 1
        animation.stiffness = 200
        animation.mass = 1
        animation.duration = 1
        animation.beginTime = CACurrentMediaTime()
        animation.fillMode = CAMediaTimingFillMode.backwards
        
        imageView.layer.add(animation, forKey: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
