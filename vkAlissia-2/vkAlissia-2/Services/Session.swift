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
    
    var token: String?
    var userId: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: userIdKey)
        }
        get {
            UserDefaults.standard.integer(forKey: userIdKey)
        }
    }
    
    static let shared = Session()
    private init() {
    }
}
