//
//  NewsCodable.swift
//  vkAlissia-2
//
//  Created by Роман Колосов on 21.10.2020.
//  Copyright © 2020 Roman N. Kolosov. All rights reserved.
//

//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// data to save
class NewsItemData {
    var sourceID: Int?
    var newsText: String?
    var attachments: [Attachment]?

    init(newsItem: NewsItem) {
        
        self.sourceID = newsItem.sourceID
        self.newsText = newsItem.text
        self.attachments = newsItem.attachments
    }
}

class NewsGroupData {
    var id: Int?
    var name: String?
    var photo200: String?

    init(groupItem: NewsGroupItem) {
        
        self.id = groupItem.id
        self.name = groupItem.name
        self.photo200 = groupItem.photo200
    }
}

class NewsProfileData {
    var firstName: String?
    var photo100: String?

    init(newsProfile: NewsProfileItem) {

        self.firstName = newsProfile.firstName
        self.photo100 = newsProfile.photo100
    }
}


// MARK: - NewsFeedQuery
struct NewsFeedQuery: Codable {
    let response: Response
}

// MARK: - Response
struct Response: Codable {
    let items: [NewsItem]
    let profiles: [NewsProfileItem]
    let groups: [NewsGroupItem]
    let nextFrom: String?

    enum CodingKeys: String, CodingKey {
        case items, profiles, groups
        case nextFrom = "next_from"
    }
}

// MARK: - Group
struct NewsGroupItem: Codable {
    var id: Int?
    var name: String?
    var screenName: String?
    var isClosed: Int?
    var type: String?
    var isAdmin: Int?
    var isMember: Int?
    var isAdvertiser: Int?
    var photo50: String?
    var photo100: String?
    var photo200: String?

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

// MARK: - ResponseItem
struct NewsItem: Codable {
    var sourceID: Int?
    var date: Int?
    var canDoubtCategory, canSetCategory: Bool?
    var postType, text: String?
    var markedAsAds: Int?
    var attachments: [Attachment]?
    var postSource: PostSource?
    var comments: Comments?
    var likes: PurpleLikes?
    var reposts: Reposts?
    var views: Views?
    var isFavorite: Bool?
    var postID: Int?
    var type: String?
    var photos: Photos?

    enum CodingKeys: String, CodingKey {
        case sourceID = "source_id"
        case date
        case canDoubtCategory = "can_doubt_category"
        case canSetCategory = "can_set_category"
        case postType = "post_type"
        case text
        case markedAsAds = "marked_as_ads"
        case attachments
        case postSource = "post_source"
        case comments, likes, reposts, views
        case isFavorite = "is_favorite"
        case postID = "post_id"
        case type, photos
    }
}

// MARK: - Attachment
struct Attachment: Codable {
    var type: String?
    var photo: Photo?
}

// MARK: - Photo
struct Photo: Codable {
    var albumID: Int?
    var date: Int?
    var id: Int?
    var ownerID: Int?
    var hasTags: Bool?
    var accessKey: String?
    var postID: Int?
    var sizes: [PhotoSize]
    var text: String?
    var userID: Int?

    enum CodingKeys: String, CodingKey {
        case albumID = "album_id"
        case date, id
        case ownerID = "owner_id"
        case hasTags = "has_tags"
        case accessKey = "access_key"
        case postID = "post_id"
        case sizes, text
        case userID = "user_id"
    }
}

// MARK: - Size
struct PhotoSize: Codable {
    var height: Int?
    var url: String?
    var type: String?
    var width: Int?
}

// MARK: - Comments
struct Comments: Codable {
    var count: Int?
    var canPost: Int?
    var groupsCanPost: Bool?

    enum CodingKeys: String, CodingKey {
        case count
        case canPost = "can_post"
        case groupsCanPost = "groups_can_post"
    }
}

// MARK: - PurpleLikes
struct PurpleLikes: Codable {
    var count: Int?
    var userLikes: Int?
    var canLike: Int?
    var canPublish: Int?

    enum CodingKeys: String, CodingKey {
        case count
        case userLikes = "user_likes"
        case canLike = "can_like"
        case canPublish = "can_publish"
    }
}

// MARK: - Photos
struct Photos: Codable {
    var count: Int?
    var items: [PhotosItem]
}

// MARK: - PhotosItem
struct PhotosItem: Codable {
    var albumID: Int?
    var date: Int?
    var id: Int?
    var ownerID: Int?
    var hasTags: Bool?
    var accessKey: String?
    var postID: Int?
    var sizes: [Size]
    var text: String?
    var userID: Int?
    var likes: FluffyLikes
    var reposts: Reposts
    var comments: Views
    var canComment: Int?
    var canRepost: Int?

    enum CodingKeys: String, CodingKey {
        case albumID = "album_id"
        case date, id
        case ownerID = "owner_id"
        case hasTags = "has_tags"
        case accessKey = "access_key"
        case postID = "post_id"
        case sizes, text
        case userID = "user_id"
        case likes, reposts, comments
        case canComment = "can_comment"
        case canRepost = "can_repost"
    }
}

// MARK: - Views
struct Views: Codable {
    var count: Int?
}

// MARK: - FluffyLikes
struct FluffyLikes: Codable {
    var userLikes: Int?
    var count: Int?

    enum CodingKeys: String, CodingKey {
        case userLikes = "user_likes"
        case count
    }
}

// MARK: - Reposts
struct Reposts: Codable {
    var  count: Int?
    var userReposted: Int?

    enum CodingKeys: String, CodingKey {
        case count
        case userReposted = "user_reposted"
    }
}

// MARK: - PostSource
struct PostSource: Codable {
    var type: String?
}

// MARK: - Profile
struct NewsProfileItem: Codable {
    var id: Int?
    var firstName: String?
    var lastName: String?
    var isClosed: Bool?
    var canAccessClosed: Bool?
    var sex: Int?
    var screenName: String?
    var photo50: String?
    var photo100: String?
    var online: Int?
    var onlineInfo: OnlineInfo

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
    var visible: Bool?
    var isOnline: Bool?
    var isMobile: Bool?

    enum CodingKeys: String, CodingKey {
        case visible
        case isOnline = "is_online"
        case isMobile = "is_mobile"
    }
}





//============================================================================
// JSON from Charles
//============================================================================
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

//import Foundation
//
//// data to save
////class NewsItemdData {
////
////    var newsText: String = ""
////    //var newsImageURL: String = ""
////    //var newsProviderName: String = ""
////    //var newsProviderAvatarURL: String = ""
////
////
////    init(newsItem: NewsItemOfItem) {
////
////        self.newsText = newsItem.text
////        //self.newsImageURL = newsItem.attachments[1].link.url
////    }
////}
//
//// MARK: - NewsFeedQuery
//struct NewsFeedQuery: Codable {
//    let response: Response
//}
//
//// MARK: - Response
//struct Response: Codable {
//    let items: [NewsItem]
//    let profiles: [ProfileNewsItem]
//    let groups: [GroupNewsItem]
//    let nextFrom: String
//
//    enum CodingKeys: String, CodingKey {
//        case items, profiles, groups
//        case nextFrom = "next_from"
//    }
//}
//
//
////class Response: Codable {
////    var items: [NewsItem]?
////    var profiles: [ProfileNewsItem]?
////    var groups: [GroupNewsItem]?
////    var nextFrom: String
////
////    enum CodingKeys: String, CodingKey {
////        case items, profiles, groups
////        case nextFrom = "next_from"
////    }
////
////    required convenience init(from decoder: Decoder) throws {
////        let container = try decoder.container(keyedBy: CodingKeys.self)
////        let items = try container.decodeIfPresent([NewsItem].self, forKey: .items)
////        let profiles = try container.decodeIfPresent([ProfileNewsItem].self, forKey: .profiles)
////        let groups = try container.decodeIfPresent([GroupNewsItem].self, forKey: .groups)
////        let nextFrom = try container.decodeIfPresent(String.self, forKey: .nextFrom) ?? ""
////
////        self.init(items: items, profiles: profiles, groups: groups, nextFrom: nextFrom)
////    }
////
////    init(items: [NewsItem]?, profiles: [ProfileNewsItem]?, groups: [GroupNewsItem]?, nextFrom: String) {
////
////        self.items = items
////        self.profiles = profiles
////        self.groups = groups
////        self.nextFrom = nextFrom
////    }
////}
//
//
//// MARK: - Group
//struct GroupNewsItem: Codable {
//    let id: Int
//    let name, screenName: String
//    let isClosed: Int
//    let type: String
//    let isAdmin, isMember, isAdvertiser: Int
//    let photo50, photo100, photo200: String
//
//    enum CodingKeys: String, CodingKey {
//        case id, name
//        case screenName = "screen_name"
//        case isClosed = "is_closed"
//        case type
//        case isAdmin = "is_admin"
//        case isMember = "is_member"
//        case isAdvertiser = "is_advertiser"
//        case photo50 = "photo_50"
//        case photo100 = "photo_100"
//        case photo200 = "photo_200"
//    }
//}
//
//// MARK: - Item
//class NewsItem: Codable {
//    var sourceID, date: Int
//    var canDoubtCategory, canSetCategory: Bool
//    var postType, text: String
//    var markedAsAds: Int
//    var attachments: [Attachment]
//    var comments, likes, reposts, views: Comments
//    var isFavorite: Bool
//    var postID: Int
//    var type: String
//
//    enum CodingKeys: String, CodingKey {
//        case sourceID = "source_id"
//        case date
//        case canDoubtCategory = "can_doubt_category"
//        case canSetCategory = "can_set_category"
//        case postType = "post_type"
//        case text
//        case markedAsAds = "marked_as_ads"
//        case attachments, comments, likes, reposts, views
//        case isFavorite = "is_favorite"
//        case postID = "post_id"
//        case type
//    }
//
//    required convenience init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        let sourceID = try container.decodeIfPresent(Int.self, forKey: .sourceID) ?? 0
//        let date = try container.decodeIfPresent(Int.self, forKey: .date) ?? 0
//        let canDoubtCategory = try container.decodeIfPresent(Bool.self, forKey: .canDoubtCategory) ?? false
//        let canSetCategory = try container.decodeIfPresent(Bool.self, forKey: .canSetCategory) ?? false
//        let postType = try container.decodeIfPresent(String.self, forKey: .postType) ?? ""
//        let text = try container.decodeIfPresent(String.self, forKey: .text) ?? ""
//        let markedAsAds = try container.decodeIfPresent(Int.self, forKey: .markedAsAds) ?? 0
//        let attachments = try container.decode([Attachment].self, forKey: .attachments)
//        let comments = try container.decode(Comments.self, forKey: .comments)
//        let likes = try container.decode(Comments.self, forKey: .likes)
//        let reposts = try container.decode(Comments.self, forKey: .reposts)
//        let views = try container.decode(Comments.self, forKey: .views)
//        let isFavorite = try container.decodeIfPresent(Bool.self, forKey: .isFavorite) ?? false
//        let postID = try container.decodeIfPresent(Int.self, forKey: .postID) ?? 0
//        let type = try container.decodeIfPresent(String.self, forKey: .type) ?? ""
//
//        self.init(sourceID: sourceID, date: date, canDoubtCategory: canDoubtCategory, canSetCategory: canSetCategory, postType: postType, text: text, markedAsAds: markedAsAds, attachments: attachments, comments: comments, likes: likes, reposts: reposts, views: views, isFavorite: isFavorite, postID: postID, type: type)
//    }
//
//    init(sourceID: Int, date: Int, canDoubtCategory: Bool, canSetCategory: Bool, postType: String, text: String, markedAsAds: Int, attachments: [Attachment], comments: Comments, likes: Comments, reposts: Comments, views: Comments, isFavorite: Bool, postID: Int, type: String) {
//        self.sourceID = sourceID
//        self.date = date
//        self.canDoubtCategory = canDoubtCategory
//        self.canSetCategory = canSetCategory
//        self.postType = postType
//        self.text = text
//        self.markedAsAds = markedAsAds
//        self.attachments = attachments
//        self.comments = comments
//        self.likes = likes
//        self.reposts = reposts
//        self.views = views
//        self.isFavorite = isFavorite
//        self.postID = postID
//        self.type = type
//    }
//}
//
//// MARK: - Attachment
//class Attachment: Codable {
//    var type: String
//    var link: Link
//
//    required convenience init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        let type = try container.decodeIfPresent(String.self, forKey: .type) ?? ""
//        let link = try container.decode(Link.self, forKey: .link)
//
//        self.init(type: type, link: link)
//    }
//
//    init(type: String, link: Link) {
//        self.type = type
//        self.link = link
//    }
//}
//
//// MARK: - Link
//class Link: Codable {
//    var url: String
//    var title, caption, linkDescription: String
//    var photo: Photo
//    var isFavorite: Bool
//
//    enum CodingKeys: String, CodingKey {
//        case url, title, caption
//        case linkDescription = "description"
//        case photo
//        case isFavorite = "is_favorite"
//    }
//
//    required convenience init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        let url = try container.decodeIfPresent(String.self, forKey: .url) ?? ""
//        let title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
//        let caption = try container.decodeIfPresent(String.self, forKey: .caption) ?? ""
//        let linkDescription = try container.decodeIfPresent(String.self, forKey: .linkDescription) ?? ""
//        let photo = try container.decode(Photo.self, forKey: .photo)
//        let isFavorite = try container.decodeIfPresent(Bool.self, forKey: .isFavorite) ?? false
//
//        self.init(url: url, title: title, caption: caption, linkDescription: linkDescription, photo: photo, isFavorite: isFavorite)
//    }
//
//    init(url: String, title: String, caption: String, linkDescription: String, photo: Photo, isFavorite: Bool) {
//        self.url = url
//        self.title = title
//        self.caption = caption
//        self.linkDescription = linkDescription
//        self.photo = photo
//        self.isFavorite = isFavorite
//    }
//}
//
//// MARK: - Photo
//class Photo: Codable {
//    var albumID, date, id, ownerID: Int
//    var hasTags: Bool
//    var sizes: [SizePhoto]
//    var text: String
//    var userID: Int
//
//    enum CodingKeys: String, CodingKey {
//        case albumID = "album_id"
//        case date, id
//        case ownerID = "owner_id"
//        case hasTags = "has_tags"
//        case sizes, text
//        case userID = "user_id"
//    }
//
//    required convenience init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        let albumID = try container.decodeIfPresent(Int.self, forKey: .albumID) ?? 0
//        let date = try container.decodeIfPresent(Int.self, forKey: .date) ?? 0
//        let id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
//        let ownerID = try container.decodeIfPresent(Int.self, forKey: .ownerID) ?? 0
//        let hasTags = try container.decodeIfPresent(Bool.self, forKey: .hasTags) ?? false
//        let sizes = try container.decode([SizePhoto].self, forKey: .sizes)
//        let text = try container.decodeIfPresent(String.self, forKey: .text) ?? ""
//        let userID = try container.decodeIfPresent(Int.self, forKey: .userID) ?? 0
//
//        self.init(albumID: albumID, date: date, id: id, ownerID: ownerID, hasTags: hasTags, sizes: sizes, text: text, userID: userID)
//    }
//
//    init(albumID: Int, date: Int, id: Int, ownerID: Int, hasTags: Bool, sizes: [SizePhoto], text: String, userID: Int) {
//        self.albumID = albumID
//        self.date = date
//        self.id = id
//        self.ownerID = ownerID
//        self.hasTags = hasTags
//        self.sizes = sizes
//        self.text = text
//        self.userID = userID
//    }
//}
//
//// MARK: - Size
//class SizePhoto: Codable {
//    var height: Int
//    var url: String
//    var type: String
//    var width: Int
//
//    required convenience init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        let height = try container.decodeIfPresent(Int.self, forKey: .height) ?? 0
//        let url = try container.decodeIfPresent(String.self, forKey: .url) ?? ""
//        let type = try container.decodeIfPresent(String.self, forKey: .type) ?? ""
//        let width = try container.decodeIfPresent(Int.self, forKey: .width) ?? 0
//
//        self.init(height: height, url: url, type: type, width: width)
//    }
//
//    init(height: Int, url: String, type: String, width: Int) {
//        self.height = height
//        self.url = url
//        self.type = type
//        self.width = width
//    }
//}
//
//// MARK: - Comments
//class Comments: Codable {
//    var count: Int
//
//    required convenience init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        let count = try container.decodeIfPresent(Int.self, forKey: .count) ?? 0
//
//        self.init(count: count)
//    }
//
//    init(count: Int) {
//        self.count = count
//    }
//}
//
//// MARK: - Profile
//struct ProfileNewsItem: Codable {
//    let id: Int
//    let firstName, lastName: String
//    let isClosed, canAccessClosed: Bool
//    let sex: Int
//    let screenName: String
//    let photo50, photo100: String
//    let online: Int
//    let onlineInfo: OnlineInfo
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case firstName = "first_name"
//        case lastName = "last_name"
//        case isClosed = "is_closed"
//        case canAccessClosed = "can_access_closed"
//        case sex
//        case screenName = "screen_name"
//        case photo50 = "photo_50"
//        case photo100 = "photo_100"
//        case online
//        case onlineInfo = "online_info"
//    }
//}
//
//// MARK: - OnlineInfo
//struct OnlineInfo: Codable {
//    let visible, isOnline, isMobile: Bool
//
//    enum CodingKeys: String, CodingKey {
//        case visible
//        case isOnline = "is_online"
//        case isMobile = "is_mobile"
//    }
//}
//
