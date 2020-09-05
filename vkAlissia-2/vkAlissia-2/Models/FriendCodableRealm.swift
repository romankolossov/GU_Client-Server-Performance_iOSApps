//
//  FriendCodableRealm.swift
//  vkAlissia-2
//
//  Created by Роман Колосов on 20.08.2020.
//  Copyright © 2020 Roman N. Kolosov. All rights reserved.
//

import Foundation
import RealmSwift

// data to save
class FriendData: Object {
    //@objc dynamic var id: Int = 0
    var id = RealmOptional<Int>()
    @objc dynamic var friendName: String = ""
    @objc dynamic var friendAvatarURL: String = ""
    
    override class func primaryKey() -> String? {
           return "id"
       }
    override static func indexedProperties() -> [String] {
        return ["friendName"]
    }
    
    init(friendItem: FriendItem) {
        self.id = friendItem.id
        self.friendName = friendItem.firstName
        self.friendAvatarURL = friendItem.photo50
    }
    
    required init() {
        super.init()
    }
}

// MARK: - Codable

struct FriendQuery: Codable {
    let response: FriendResponse
}

struct FriendResponse: Codable {
    let count: Int
    let items: [FriendItem]
}

class FriendItem: Object, Codable {
    //@objc dynamic var id: Int = 0
    var id = RealmOptional<Int>()
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var domain: String = ""
    @objc dynamic var photo50: String = ""
    @objc dynamic var city: City? = nil
    @objc dynamic var online: Int = 0

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case photo50 = "photo_50"
        case domain, city, online
    }
    
//    override class func ignoredProperties() -> [String] {
//        return ["id", "firstName", "lastName", "domain", "photo50", "city", "online"]
//    }
    
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        //let id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        let id = try container.decode(RealmOptional<Int>.self, forKey: .id)
        let firstName = try container.decodeIfPresent(String.self, forKey: .firstName) ?? ""
        let lastName = try container.decodeIfPresent(String.self, forKey: .lastName) ?? ""
        let domain = try container.decodeIfPresent(String.self, forKey: .domain) ?? ""
        let photo50 = try container.decodeIfPresent(String.self, forKey: .photo50) ?? ""
        let city = try container.decode(City.self, forKey: .city)
        let online = try container.decodeIfPresent(Int.self, forKey: .online) ?? 0
        
        self.init(id: id, firstName: firstName, lastName: lastName, domain: domain, photo50: photo50, city: city, online: online)
    }
    
    convenience init(id: RealmOptional<Int>, firstName: String, lastName: String, domain: String, photo50: String, city: City, online: Int) {
        self.init()
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.domain = domain
        self.photo50 = photo50
        self.city = city
        self.online = online
    }
    
    required init() {
        super.init()
    }
}

class City: Object, Codable {
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        let title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        
        self.init(id: id, title: title)
    }
    
    convenience init(id: Int, title: String) {
        self.init()
        self.id = id
        self.title = title
    }
    
    required init() {
        super.init()
    }
}
