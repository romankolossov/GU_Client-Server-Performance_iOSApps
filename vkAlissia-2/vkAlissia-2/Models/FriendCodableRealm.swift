//
//  FriendCodableRealm.swift
//  vkAlissia-2
//
//  Created by Роман Колосов on 20.08.2020.
//  Copyright © 2020 Roman N. Kolosov. All rights reserved.
//

import Foundation
import RealmSwift

// MARK: - FriendQuery
struct FriendQuery: Codable {
    let response: FriendResponse
}

// MARK: - FriendResponse
struct FriendResponse: Codable {
    let count: Int
    let items: [FriendItem]
}

// MARK: - FriendItem
class FriendItem: Object, Codable {
    @objc dynamic var id: Int = 0
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var domain: String = ""
    @objc dynamic var city: City?
    @objc dynamic var online: Int = 0

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case domain, city, online
    }
    
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        let firstName = try container.decodeIfPresent(String.self, forKey: .firstName) ?? ""
        let lastName = try container.decodeIfPresent(String.self, forKey: .lastName) ?? ""
        let domain = try container.decodeIfPresent(String.self, forKey: .domain) ?? ""
        let city = try container.decodeIfPresent(City.self, forKey: .city) ?? City(id: 0, title: "")
        let online = try container.decodeIfPresent(Int.self, forKey: .online) ?? 0
        
        self.init(id: id, firstName: firstName, lastName: lastName, domain: domain, city: city, online: online)
    }
    
    convenience init(id: Int, firstName: String, lastName: String, domain: String, city: City, online: Int) {
        self.init()
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.domain = domain
        self.city = city
        self.online = online
    }
    
    required init() {
        super.init()
    }
}

// MARK: - City
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
