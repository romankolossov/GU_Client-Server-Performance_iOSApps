//
//  GroupCodableRealm.swift
//  vkAlissia-2
//
//  Created by Роман Колосов on 20.08.2020.
//  Copyright © 2020 Roman N. Kolosov. All rights reserved.
//

import Foundation
import RealmSwift

// MARK: - GroupQuery
struct GroupQuery: Codable {
    let response: GroupResponse
}

// MARK: - GroupResponse
struct GroupResponse: Codable {
    let count: Int
    let items: [GroupItem]
}

// MARK: - GroupItem
struct GroupItem: Codable {
    let id: Int
    let name, screenName: String
    let isClosed: Int
    let type: String
    let isAdmin, isMember, isAdvertiser: Int
    let photo50, photo100, photo200: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case screenName = "screen_name"
        case isClosed = "is_closed"
        case type
        case isAdmin = "is_admin"
        case isMember = "is_member"
        case isAdvertiser = "is_advertiser"
        case photo50 = "photo_50"
        case photo100 = "photo_100"
        case photo200 = "photo_200"
    }
}
