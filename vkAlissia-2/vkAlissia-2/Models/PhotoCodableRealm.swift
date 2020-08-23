//
//  PhotoCodableRealm.swift
//  vkAlissia-2
//
//  Created by Роман Колосов on 20.08.2020.
//  Copyright © 2020 Roman N. Kolosov. All rights reserved.
//

import Foundation
import RealmSwift

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
class PhotoItem: Object, Codable {
    @objc dynamic var id: Int = 0
    @objc dynamic var albumID: Int = 0
    @objc dynamic var ownerID: Int = 0
    @objc dynamic var userID: Int = 0
    dynamic var sizes = List<Size>()
    @objc dynamic var text: String = ""
    @objc dynamic var date: Int = 0

    enum CodingKeys: String, CodingKey {
        case id
        case albumID = "album_id"
        case ownerID = "owner_id"
        case userID = "user_id"
        case sizes, text, date
    }
    
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        let albumID = try container.decodeIfPresent(Int.self, forKey: .albumID) ?? 0
        let ownerID = try container.decodeIfPresent(Int.self, forKey: .ownerID) ?? 0
        let userID = try container.decodeIfPresent(Int.self, forKey: .userID) ?? 0
        let sizes = try container.decodeIfPresent(List<Size>.self, forKey: .sizes) ?? List<Size>()
        let text = try container.decodeIfPresent(String.self, forKey: .text) ?? ""
        let date = try container.decodeIfPresent(Int.self, forKey: .date) ?? 0
        
        self.init(id: id, albumID: albumID, ownerID: ownerID, userID: userID, sizes: sizes, text: text, date: date)
    }
    
    convenience init(id: Int, albumID: Int, ownerID: Int, userID: Int, sizes: List<Size>, text: String, date: Int) {
        self.init()
        self.id = id
        self.albumID = albumID
        self.ownerID = ownerID
        self.userID = userID
        self.sizes = sizes
        self.text = text
        self.date = date
    }
    
    required init() {
        super.init()
    }
}

// MARK: - Size
class Size: Object, Codable {
    @objc dynamic var type: String = ""
    @objc dynamic var url: String = ""
    @objc dynamic var width: Int = 0
    @objc dynamic var height: Int = 0
    
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decodeIfPresent(String.self, forKey: .type) ?? ""
        let url = try container.decodeIfPresent(String.self, forKey: .url) ?? ""
        let width = try container.decodeIfPresent(Int.self, forKey: .width) ?? 0
        let height = try container.decodeIfPresent(Int.self, forKey: .height) ?? 0
        
        self.init(type: type, url: url, width: width, height: height)
    }
    
    convenience init(type: String, url: String, width: Int, height: Int) {
        self.init()
        self.type = type
        self.url = url
        self.width = width
        self.height = height
    }
    
    required init() {
        super.init()
    }
}
