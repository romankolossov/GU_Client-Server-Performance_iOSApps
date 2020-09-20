//
//  NewsCell.swift
//  vkAlissia
//
//  Created by Роман Колосов on 20.07.2020.
//  Copyright © 2020 Roman N. Kolosov. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {
    @IBOutlet weak var newsProviderNameLabel: UILabel!
    @IBOutlet weak var newsProviderAvatar: UIImageView!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var newsTextView: UITextView!
    
    let likeControl = LikeControl()

    override func awakeFromNib() {
        super.awakeFromNib()
        likeControl.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(likeControl)
        
        let likeConstrains = [
            likeControl.rightAnchor.constraint(equalTo: rightAnchor),
            likeControl.bottomAnchor.constraint(equalTo: bottomAnchor),
        ]
        
        NSLayoutConstraint.activate(likeConstrains)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
