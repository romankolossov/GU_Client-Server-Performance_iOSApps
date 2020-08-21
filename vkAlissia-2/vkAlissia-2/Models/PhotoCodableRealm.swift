//
//  PhotoCodableRealm.swift
//  vkAlissia-2
//
//  Created by Роман Колосов on 20.08.2020.
//  Copyright © 2020 Roman N. Kolosov. All rights reserved.
//

import Foundation

// MARK: - PhotoQuery
struct PhotoQuery: Codable {
    let response: PhotoResponse
}

// MARK: - PhotoResponse
struct PhotoResponse: Codable {
    let count: Int
    let items: [PhotoItem]
}

// MARK: - PhotoItem
struct PhotoItem: Codable {
    let id, albumID, ownerID, userID: Int
    let sizes: [Size]
    let text: String
    let date: Int

    enum CodingKeys: String, CodingKey {
        case id
        case albumID = "album_id"
        case ownerID = "owner_id"
        case userID = "user_id"
        case sizes, text, date
    }
}

// MARK: - Size
struct Size: Codable {
    let type: String
    let url: String
    let width, height: Int
}
