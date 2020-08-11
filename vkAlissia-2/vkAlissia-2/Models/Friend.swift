//
//  Friend.swift
//  vkAlissia
//
//  Created by Роман Колосов on 09.07.2020.
//  Copyright © 2020 Roman N. Kolosov. All rights reserved.
//

import UIKit

class FriendData {
    let friendName: String
    var friendAvatar: UIImage
    var favorireImages: [UIImage] = []
    
    init(friendName: String, friendAvatar: UIImage, favoriteImages: [UIImage]) {
        self.friendName = friendName
        self.friendAvatar = friendAvatar
        self.favorireImages = favoriteImages
    }
}
