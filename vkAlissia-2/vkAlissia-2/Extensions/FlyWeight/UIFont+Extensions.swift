//
//  UIFont+Extensions.swift
//  vkAlissia-2
//
//  Created by Роман Колосов on 08.11.2020.
//  Copyright © 2020 Roman N. Kolosov. All rights reserved.
//

import UIKit

extension UIFont {
    
    // used in FriendCell
    static let nameFont: UIFont = .preferredFont(forTextStyle: .title3)
    
    // used in MyGroupCell
    static let groupNameFont: UIFont = .preferredFont(forTextStyle: .body)
    
    // used in FriendsViewController, MyGroupsViewController
    static let refreshControlFont: UIFont = UIFont.systemFont(ofSize: 10)
    
    // used in FriendPhotoViewController
    static let photoFont: UIFont = .preferredFont(forTextStyle: .title1)
}

