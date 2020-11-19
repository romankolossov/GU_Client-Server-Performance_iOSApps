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
    
    // MARK: - Lifucycle
    
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
    
    // MARK: - Major Methods
    
    func lookConfigure(with photo: PhotoData, friendName: String?, photoService: ParticularFriendPhotoService?, indexPath: IndexPath) {
        
        // value of "6" (.last) is the best quality image of the VK photos to .get
        guard let photoURL = photo.sizes.last?.url else {
            print("error: nill value of 'photo.sizes.last' in:\n\(#function)\n at line: \(#line - 1)")
            fatalError()
        }
        
        nameLabel.text = friendName
        favoriteImageView.backgroundColor = UIColor.whiteBackgroundColor
        favoriteImageView.image = photoService!.getPhoto(atIndexPath: indexPath, byUrl: photoURL)
    }
}
