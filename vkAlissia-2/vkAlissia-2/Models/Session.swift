//
//  Session.swift
//  vkAlissia-2
//
//  Created by Роман Колосов on 09.08.2020.
//  Copyright © 2020 Roman N. Kolosov. All rights reserved.
//

import Foundation

import Foundation

class Session {
    private let someKey = "com.apple.my-app.money.amount"
    
    var token: String?
    var userId: Int?
    var monetAmount: Double {
        set {
            UserDefaults.standard.set(newValue, forKey: someKey)
        }
        get {
            UserDefaults.standard.double(forKey: someKey)
        }
    }
    
    static let shared = Session()
    private init() {
        
    }
}
