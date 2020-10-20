//
//  NetworkManager.swift
//  vkAlissia-2
//
//  Created by Роман Колосов on 12.08.2020.
//  Copyright © 2020 Roman N. Kolosov. All rights reserved.
//

import Foundation
import SwiftyJSON

class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    // Some properties
    enum NetworkError: Error {
        case incorrectData
    }
    
    enum Method: String {
        case groupsGet = "groups.get"
        case friendsGet = "friends.get"
        case photosGet = "photos.get"
        case newsFeedGet = "newsfeed.get"
        case groupsSearch = "groups.search"
    }
    
    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        //configuration.allowsCellularAccess = false
        let session =  URLSession(configuration: configuration)
        return session
    }()
    
    let vkAPIVersion: String = "5.122"
    
    // MARK: - Major methods
    
    func networkRequest(for method: Method, completion: ((Result<[Any], Error>) -> Void)? = nil) {
        var urlConstructor = URLComponents()
        urlConstructor.scheme = "https"
        urlConstructor.host = "api.vk.com"
        urlConstructor.path = "/method/\(method.rawValue)"
        
        switch method {
        case .groupsGet:
            urlConstructor.queryItems = [
                URLQueryItem(name: "access_token", value: "\(Session.shared.token)"),
                URLQueryItem(name: "user_id", value: "\(Session.shared.userId)"),
                URLQueryItem(name: "extended", value: "1"),
                URLQueryItem(name: "v", value: vkAPIVersion)
            ]
        case .friendsGet:
            urlConstructor.queryItems = [
                URLQueryItem(name: "access_token", value: "\(Session.shared.token)"),
                URLQueryItem(name: "user_id", value: "\(Session.shared.userId)"),
                URLQueryItem(name: "order", value: "random"),
                URLQueryItem(name: "offset", value: "5"),
                URLQueryItem(name: "fields", value: "city,country,domain,photo_200_orig"),
                URLQueryItem(name: "name_case", value: "nom"),
                URLQueryItem(name: "v", value: vkAPIVersion)
            ]
        case .photosGet:
            urlConstructor.queryItems = [
                URLQueryItem(name: "access_token", value: "\(Session.shared.token)"),
                URLQueryItem(name: "owner_id", value: String(Session.shared.friendId)),
                //URLQueryItem(name: "album_id", value: "profile"),
                URLQueryItem(name: "album_id", value: "wall"),
                URLQueryItem(name: "rev", value: "0"),
                URLQueryItem(name: "offset", value: "0"),
                URLQueryItem(name: "count", value: "30"),
                URLQueryItem(name: "v", value: vkAPIVersion)
            ]
        case .newsFeedGet:
            urlConstructor.queryItems = [
                URLQueryItem(name: "access_token", value: "\(Session.shared.token)"),
                URLQueryItem(name: "user_id", value: "\(Session.shared.userId)"),
                URLQueryItem(name: "filters", value: "post,photo,wall_photo"),
                URLQueryItem(name: "source_ids", value: "friends,groups,pages,following"),
                //URLQueryItem(name: "start_from", value: ""),
                URLQueryItem(name: "count", value: "30"),
                URLQueryItem(name: "v", value: vkAPIVersion)
            ]
        default:
            print("error: \(method.rawValue) is out of range")
            return
        }
        
        guard let url = urlConstructor.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        //request.allowsCellularAccess = false
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                switch method {
                case .friendsGet:
                    do {
                        let friends = try JSONDecoder().decode(FriendQuery.self, from: data).response.items
                        completion?(.success(friends))
                    } catch {
                        completion?(.failure(error))
                    }
                case .groupsGet:
                    do {
                        let groups = try JSONDecoder().decode(GroupQuery.self, from: data).response.items
                        completion?(.success(groups))
                    } catch {
                        completion?(.failure(error))
                    }
                case .photosGet:
                    do {
                        let photos = try JSONDecoder().decode(PhotoQuery.self, from: data).response.items
                        completion?(.success(photos))
                    } catch {
                        completion?(.failure(error))
                    }
                case .newsFeedGet:
                    do {
                        let json = try JSON(data: data)
                        #if DEBUG
                        print("data from:\n\(#function)")
                        print(data)
                        print(json)
                        #endif
                        
                        let news: [NewsItem] = json["response"]["items"].arrayValue.map { NewsItem(json: $0) }
                        let profiles: [OwnerItem] = json["response"]["profiles"].arrayValue.map { OwnerItem(json: $0) }
                        let newsGroups: [OwnerItem] = json["response"]["groups"].arrayValue.map { OwnerItem(json: $0) }
                        //let nextFrom = json["response"]["next_from"].stringValue
                        
                        //SessionApp.shared.nextFrom = nextFrom
                        let newsDataItem: VKNewsDataItem = VKNewsDataItem(news: news, profiles: profiles, newsGroups: newsGroups)
                        #if DEBUG
                        print("news, users, groups from:\n\(#function)")
                        print("\(news.count)\n\(profiles.count)\n\(newsGroups.count)" )
                        #endif
                        
                        completion?(.success([newsDataItem]))
                    } catch {
                        completion?(.failure(error))
                    }
                default:
                    print("error: \(method.rawValue) is out of range")
                    return
                }
            } else if let error = error {
                completion?(.failure(error))
            }
        }
        
        dataTask.resume()
    }
    
    // MARK: - Network load methods
    
    func loadFriends(completion: ((Result<[FriendItem], NetworkError>) -> Void)? = nil) {
        networkRequest(for: .friendsGet) {result in
            switch result {
            case let .success(friends):
                completion?(.success(friends as! [FriendItem]))
            case .failure:
                completion?(.failure(.incorrectData))
            }
        }
    }
    
    func loadGroups(completion: ((Result<[GroupItem], NetworkError>) -> Void)? = nil) {
        networkRequest(for: .groupsGet) {result in
            switch result {
            case let .success(groups):
                completion?(.success(groups as! [GroupItem]))
            case .failure:
                completion?(.failure(.incorrectData))
            }
        }
    }
    
    func loadPhotos(completion: ((Result<[PhotoItem], NetworkError>) -> Void)? = nil) {
        networkRequest(for: .photosGet) {result in
            switch result {
            case let .success(photos):
                completion?(.success(photos as! [PhotoItem]))
            case .failure:
                completion?(.failure(.incorrectData))
            }
        }
    }
    
    func loadNewsFeed(completion: ((Result<[VKNewsDataItem], NetworkError>) -> Void)? = nil) {
        networkRequest(for: .newsFeedGet) {result in
            switch result {
            case let .success(newsDataArray):
                completion?(.success(newsDataArray as! [VKNewsDataItem]))
            case .failure:
                completion?(.failure(.incorrectData))
            }
        }
    }
}
