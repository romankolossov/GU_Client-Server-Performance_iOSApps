//
//  FriendCodable.swift
//  vkAlissia-2
//
//  Created by Роман Колосов on 20.08.2020.
//  Copyright © 2020 Roman N. Kolosov. All rights reserved.
//

import Foundation

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
struct FriendItem: Codable {
    let id: Int
    let firstName, lastName, domain: String
    let city: City
    let online: Int

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case domain, city, online
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let firstName = try container.decode(String.self, forKey: .firstName)
        let lastName = try container.decode(String.self, forKey: .lastName)
        let domain = try container.decode(String.self, forKey: .domain)
        let city = try container.decode(City.self, forKey: .city)
        let online = try container.decode(Int.self, forKey: .online)
        
        self.init(id: id, firstName: firstName, lastName: lastName, domain: domain, city: city, online: online)
    }
    
    init(id: Int, firstName: String, lastName: String, domain: String, city: City, online: Int) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.domain = domain
        self.city = city
        self.online = online
    }
}

// MARK: - City
struct City: Codable {
    let id: Int
    let title: String
}
