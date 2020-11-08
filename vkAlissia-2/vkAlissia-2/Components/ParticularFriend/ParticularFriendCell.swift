//
//  CertainFriendCell.swift
//  vkAlissia
//
//  Created by Роман Колосов on 11.07.2020.
//  Copyright © 2020 Roman N. Kolosov. All rights reserved.
//

import UIKit

class ParticularFriendCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var backView: UIView!
    
    let likeControl = LikeControl()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        likeControl.translatesAutoresizingMaskIntoConstraints = false
        
        backView.layer.cornerRadius = 10
        backView.layer.borderColor = UIColor.greenBorderColor.cgColor
        backView.layer.borderWidth = 1
        
        contentView.addSubview(likeControl)
        
        let likeConstrains = [
            likeControl.rightAnchor.constraint(equalTo: rightAnchor),
            likeControl.bottomAnchor.constraint(equalTo: bottomAnchor),
        ]
        
        NSLayoutConstraint.activate(likeConstrains)
    }
}
