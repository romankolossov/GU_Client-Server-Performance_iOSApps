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

// data to save
//class NewsItemdData {
//    
//    var newsText: String = ""
//    //var newsImageURL: String = ""
//    //var newsProviderName: String = ""
//    //var newsProviderAvatarURL: String = ""
//    
//    
//    init(newsItem: NewsItemOfItem) {
//       
//        self.newsText = newsItem.text
//        //self.newsImageURL = newsItem.attachments[1].link.url
//    }
//}

// MARK: - NewsFeedQuery
struct NewsFeedQuery: Codable {
    let response: Response
}

// MARK: - Response
struct Response: Codable {
    let items: [NewsItemOfItem]
    let profiles: [ProfileNewsItem]
    let groups: [GroupNewsItem]
    let nextFrom: String

    enum CodingKeys: String, CodingKey {
        case items, profiles, groups
        case nextFrom = "next_from"
    }
}

// MARK: - Group
struct GroupNewsItem: Codable {
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

// MARK: - Item
struct NewsItemOfItem: Codable {
    let sourceID, date: Int
    let canDoubtCategory, canSetCategory: Bool
    let postType, text: String
    let markedAsAds: Int
    let attachments: [Attachment]
    let comments, likes, reposts, views: Comments
    let isFavorite: Bool
    let postID: Int
    let type: String

    enum CodingKeys: String, CodingKey {
        case sourceID = "source_id"
        case date
        case canDoubtCategory = "can_doubt_category"
        case canSetCategory = "can_set_category"
        case postType = "post_type"
        case text
        case markedAsAds = "marked_as_ads"
        case attachments, comments, likes, reposts, views
        case isFavorite = "is_favorite"
        case postID = "post_id"
        case type
    }
}

// MARK: - Attachment
struct Attachment: Codable {
    let type: String
    let link: Link
}

// MARK: - Link
struct Link: Codable {
    let url: String
    let title, caption, linkDescription: String
    let photo: Photo
    let isFavorite: Bool

    enum CodingKeys: String, CodingKey {
        case url, title, caption
        case linkDescription = "description"
        case photo
        case isFavorite = "is_favorite"
    }
}

// MARK: - Photo
struct Photo: Codable {
    let albumID, date, id, ownerID: Int
    let hasTags: Bool
    let sizes: [SizePhoto]
    let text: String
    let userID: Int

    enum CodingKeys: String, CodingKey {
        case albumID = "album_id"
        case date, id
        case ownerID = "owner_id"
        case hasTags = "has_tags"
        case sizes, text
        case userID = "user_id"
    }
}

// MARK: - Size
struct SizePhoto: Codable {
    let height: Int
    let url: String
    let type: String
    let width: Int
}

// MARK: - Comments
struct Comments: Codable {
    let count: Int
}

// MARK: - Profile
struct ProfileNewsItem: Codable {
    let id: Int
    let firstName, lastName: String
    let isClosed, canAccessClosed: Bool
    let sex: Int
    let screenName: String
    let photo50, photo100: String
    let online: Int
    let onlineInfo: OnlineInfo

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case isClosed = "is_closed"
        case canAccessClosed = "can_access_closed"
        case sex
        case screenName = "screen_name"
        case photo50 = "photo_50"
        case photo100 = "photo_100"
        case online
        case onlineInfo = "online_info"
    }
}

// MARK: - OnlineInfo
struct OnlineInfo: Codable {
    let visible, isOnline, isMobile: Bool

    enum CodingKeys: String, CodingKey {
        case visible
        case isOnline = "is_online"
        case isMobile = "is_mobile"
    }
}

