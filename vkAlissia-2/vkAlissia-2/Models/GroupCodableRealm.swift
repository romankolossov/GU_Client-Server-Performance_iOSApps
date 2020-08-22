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
class GroupItem: Codable {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var screenName: String = ""
    @objc dynamic var isClosed: Int = 0
    @objc dynamic var type: String = ""
    @objc dynamic var isAdmin: Int = 0
    @objc dynamic var isMember: Int = 0
    @objc dynamic var isAdvertiser: Int = 0
    @objc dynamic var photo50: String = ""
    @objc dynamic var photo100: String = ""
    @objc dynamic var photo200: String = ""

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
    
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        let name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        let screenName = try container.decodeIfPresent(String.self, forKey: .screenName) ?? ""
        let isClosed = try container.decodeIfPresent(Int.self, forKey: .isClosed) ?? 0
        let type = try container.decodeIfPresent(String.self, forKey: .type) ?? ""
        let isAdmin = try container.decodeIfPresent(Int.self, forKey: .isAdmin) ?? 0
        let isMember = try container.decodeIfPresent(Int.self, forKey: .isMember) ?? 0
        let isAdvertiser = try container.decodeIfPresent(Int.self, forKey: .isAdvertiser) ?? 0
        let photo50 = try container.decodeIfPresent(String.self, forKey: .photo50) ?? ""
        let photo100 = try container.decodeIfPresent(String.self, forKey: .photo100) ?? ""
        let photo200 = try container.decodeIfPresent(String.self, forKey: .photo200) ?? ""
        
        self.init(id: id, name: name, screenName: screenName, isClosed: isClosed, type: type, isAdmin: isAdmin, isMember: isMember, isAdvertiser: isAdvertiser, photo50: photo50, photo100: photo100, photo200: photo200)
    }
    
    init(id: Int, name: String, screenName: String, isClosed: Int, type: String, isAdmin: Int, isMember: Int, isAdvertiser: Int, photo50: String, photo100: String, photo200: String) {
        self.id = id
        self.name = name
        self.screenName = screenName
        self.isClosed = isClosed
        self.type = type
        self.isAdmin = isAdmin
        self.isMember = isMember
        self.isAdvertiser = isAdvertiser
        self.photo50 = photo50
        self.photo100 = photo100
        self.photo200 = photo200
    }
}
