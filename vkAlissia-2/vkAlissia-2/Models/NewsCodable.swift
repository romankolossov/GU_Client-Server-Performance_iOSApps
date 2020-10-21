//
//  NewsCodable.swift
//  vkAlissia-2
//
//  Created by Роман Колосов on 21.10.2020.
//  Copyright © 2020 Roman N. Kolosov. All rights reserved.
//



// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct NewsFeedQuery: Codable {
    let response: Response
}

// MARK: - Response
struct Response: Codable {
    let profiles: [JSONAny]
    let items: [ItemNewsItem]
    let groups: [GroupNewsItem]
}

// MARK: - Group
struct GroupNewsItem: Codable {
    let photo50: String
    let isMember, id, isAdvertiser: Int
    let photo100: String
    let isClosed: Int
    let type, screenName: String
    let isAdmin: Int
    let name: String
    let photo200: String

    enum CodingKeys: String, CodingKey {
        case photo50 = "photo_50"
        case isMember = "is_member"
        case id
        case isAdvertiser = "is_advertiser"
        case photo100 = "photo_100"
        case isClosed = "is_closed"
        case type
        case screenName = "screen_name"
        case isAdmin = "is_admin"
        case name
        case photo200 = "photo_200"
    }
}

// MARK: - Item
struct ItemNewsItem: Codable {
    let canSetCategory: Bool
    let comments: Comments
    let attachments: [Attachment]
    let postType: String
    let postID: Int
    let views: Comments
    let markedAsAds: Int
    let likes: Comments
    let canDoubtCategory: Bool
    let text: String
    let date: Int
    let type: String
    let reposts: Comments
    let isFavorite: Bool
    let sourceID: Int

    enum CodingKeys: String, CodingKey {
        case canSetCategory = "can_set_category"
        case comments, attachments
        case postType = "post_type"
        case postID = "post_id"
        case views
        case markedAsAds = "marked_as_ads"
        case likes
        case canDoubtCategory = "can_doubt_category"
        case text, date, type, reposts
        case isFavorite = "is_favorite"
        case sourceID = "source_id"
    }
}

// MARK: - Attachment
struct Attachment: Codable {
    let video: Video?
    let type: String
    let link: Link?
}

// MARK: - Link
struct Link: Codable {
    let isFavorite: Bool
    let title, target: String
    let url: String
    let linkDescription: String

    enum CodingKeys: String, CodingKey {
        case isFavorite = "is_favorite"
        case title, target, url
        case linkDescription = "description"
    }
}

// MARK: - Video
struct Video: Codable {
    let date, ownerID, id: Int
    let type, title: String
    let duration: Int
    let trackCode: String
    let canComment, views, canLike: Int
    let videoDescription: String
    let comments: Int
    let accessKey: String
    let canAddToFaves: Int
    let platform: String
    let canSubscribe, localViews: Int
    let image: [Image]
    let canAdd, canRepost: Int
    let isFavorite: Bool

    enum CodingKeys: String, CodingKey {
        case date
        case ownerID = "owner_id"
        case id, type, title, duration
        case trackCode = "track_code"
        case canComment = "can_comment"
        case views
        case canLike = "can_like"
        case videoDescription = "description"
        case comments
        case accessKey = "access_key"
        case canAddToFaves = "can_add_to_faves"
        case platform
        case canSubscribe = "can_subscribe"
        case localViews = "local_views"
        case image
        case canAdd = "can_add"
        case canRepost = "can_repost"
        case isFavorite = "is_favorite"
    }
}

// MARK: - Image
struct Image: Codable {
    let height, withPadding: Int
    let url: String
    let width: Int

    enum CodingKeys: String, CodingKey {
        case height
        case withPadding = "with_padding"
        case url, width
    }
}

// MARK: - Comments
struct Comments: Codable {
    let count: Int
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
        return nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    var intValue: Int? {
        return nil
    }

    var stringValue: String {
        return key
    }
}

class JSONAny: Codable {

    let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }

    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }

    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
}

