//
//  FriendCell.swift
//  vkAlissia
//
//  Created by Роман Колосов on 09.07.2020.
//  Copyright © 2020 Roman N. Kolosov. All rights reserved.
//

import UIKit

class FriendCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var friendAvatarView: UIImageView!
    @IBOutlet weak var shadowView: UIView!
    var favoriteImages: [UIImage] = []
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        shadowView?.layer.cornerRadius = shadowView.bounds.height
        shadowView?.layer.shadowColor = UIColor.black.cgColor
        shadowView?.layer.shadowOpacity = 0.8
        shadowView?.layer.shadowRadius = 8
        shadowView?.layer.shadowOffset = CGSize.zero
        shadowView?.layer.shadowPath = UIBezierPath(ovalIn: shadowView.bounds).cgPath
        
        friendAvatarView?.layer.cornerRadius = friendAvatarView.bounds.height / 2
        friendAvatarView?.contentMode = .scaleAspectFill
        friendAvatarView?.clipsToBounds = true
        
        friendAvatarView.isUserInteractionEnabled = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onAvatarTapped(_:)))
        friendAvatarView.addGestureRecognizer(gesture)
    }
    
    @objc func onAvatarTapped(_ gesture: UIGestureRecognizer) {
        animateAvatarView()
        //        sendActions(for: .valueChanged)
    }
    
    func animateAvatarView() {
        let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.fromValue = 0
        animation.byValue = 1
        animation.stiffness = 230
        animation.mass = 1.3
        animation.duration = 2
        animation.beginTime = CACurrentMediaTime()
        animation.fillMode = CAMediaTimingFillMode.backwards
        
        friendAvatarView.layer.add(animation, forKey: nil)
        shadowView.layer.add(animation, forKey: nil)
    }
}
