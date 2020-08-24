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
}

// MARK: - City
struct City: Codable {
    let id: Int
    let title: String
}
