//
//  MyGroupCell.swift
//  vkAlissia
//
//  Created by Роман Колосов on 19.07.2020.
//  Copyright © 2020 Roman N. Kolosov. All rights reserved.
//

import UIKit

class MyGroupCell: UITableViewCell {
    @IBOutlet weak var myGroupNameLabel: UILabel!
    @IBOutlet weak var myGroupAvatarView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
