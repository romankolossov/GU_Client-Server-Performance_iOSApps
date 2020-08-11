//
//  Group.swift
//  vkAlissia
//
//  Created by Роман Колосов on 09.07.2020.
//  Copyright © 2020 Roman N. Kolosov. All rights reserved.
//

import UIKit

class GroupData {
    let groupName: String
    var groupAvatar: UIImage
    
    init(groupName: String, groupAvatar: UIImage) {
        self.groupName = groupName
        self.groupAvatar = groupAvatar
    }
}
