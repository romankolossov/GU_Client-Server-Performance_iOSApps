//
//  Session.swift
//  vkAlissia-2
//
//  Created by Роман Колосов on 09.08.2020.
//  Copyright © 2020 Roman N. Kolosov. All rights reserved.
//

import Foundation

class Session {
    private let userIdKey = "com.apple.vkAlissia.user.id"
    private let friendIdKey = "com.apple.vkAlissia.friend.id"
    
    // set in: extension LoginFormController
    var token: String = ""
    var userId: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: userIdKey)
        }
        get {
            UserDefaults.standard.integer(forKey: userIdKey)
        }
    }
    
    // set in: extension FriendsViewController
    var friendId: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: friendIdKey)
        }
        get {
            UserDefaults.standard.integer(forKey: friendIdKey)
        }
    }
    
    static let shared = Session()
    private init() {
    }
}
