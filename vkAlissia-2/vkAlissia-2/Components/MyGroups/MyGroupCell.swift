//
//  MyGroupCell.swift
//  vkAlissia
//
//  Created by Роман Колосов on 19.07.2020.
//  Copyright © 2020 Roman N. Kolosov. All rights reserved.
//

import UIKit
import SDWebImage

class MyGroupCell: UITableViewCell {
    @IBOutlet weak var myGroupNameLabel: UILabel!
    @IBOutlet weak var myGroupAvatarView: UIImageView!
    
    // View model
    var groupModel: GroupData? {
        didSet {
            setup()
        }
    }
    
    // Build data
    private func setup() {
        guard let groupModel = groupModel else { return }
        
        //let id = groupModel.id.value ?? -1
        let groupName = groupModel.groupName
        let groupAvatarURL = groupModel.groupAvatarUrl
        
        myGroupNameLabel.text = groupName
        myGroupAvatarView.sd_setImage(with: URL(string: groupAvatarURL))
    }
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
