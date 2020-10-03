//
//  NetworkManagerPromise.swift
//  vkAlissia-2
//
//  Created by Роман Колосов on 27.09.2020.
//  Copyright © 2020 Roman N. Kolosov. All rights reserved.
//

import Foundation
import PromiseKit

class NetworkManagerPromise {
    
    static let shared = NetworkManagerPromise()
    private init() {}
    
    // Some properties
    enum NetworkError: Error {
        case incorrectData
    }
    
    enum ParsingError: Error {
        case groupsDecodingFailure
        case friendsDecodingFailure
        case photosDecodingFailure
        case newsFeedDecodingFailure
        case groupsSearchDecodingFailure
    }
    
    enum PromiseError: Error {
        case promiseRejected
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
    
    func networkRequest(for method: Method) -> Promise<[Any]> {
        var urlConstructor = URLComponents()
        urlConstructor.scheme = "https"
        urlConstructor.host = "api.vk.com"
        urlConstructor.path = "/method/\(method.rawValue)"
        
        switch method {
        case .groupsGet:
            urlConstructor.queryItems = [
                URLQueryItem(name: "access_token", value: Session.shared.token),
                URLQueryItem(name: "user_id", value: "\(Session.shared.userId)"),
                URLQueryItem(name: "extended", value: "1"),
                URLQueryItem(name: "v", value: vkAPIVersion)
            ]
        case .friendsGet:
            urlConstructor.queryItems = [
                URLQueryItem(name: "access_token", value: Session.shared.token),
                URLQueryItem(name: "user_id", value: "\(Session.shared.userId)"),
                URLQueryItem(name: "order", value: "random"),
                URLQueryItem(name: "offset", value: "5"),
                URLQueryItem(name: "fields", value: "city,country,domain,photo_200_orig"),
                URLQueryItem(name: "name_case", value: "nom"),
                URLQueryItem(name: "v", value: vkAPIVersion)
            ]
        case .photosGet:
            urlConstructor.queryItems = [
                URLQueryItem(name: "access_token", value: Session.shared.token),
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
                URLQueryItem(name: "access_token", value: Session.shared.token),
                URLQueryItem(name: "user_id", value: "\(Session.shared.userId)"),
                URLQueryItem(name: "filters", value: "post,photo,wall_photo,friend,note"),
                URLQueryItem(name: "source_ids", value: "friends,groups,pages,following"),
                URLQueryItem(name: "v", value: vkAPIVersion)
            ]
        default:
            print("error: \(method.rawValue) is out of range")
            return Promise { Resolver in Resolver.reject(PromiseError.promiseRejected)
            }
        }
        
        guard let url = urlConstructor.url else { fatalError() }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        //request.allowsCellularAccess = false
        
        return session.dataTask(.promise, with: request)
            .then(on: DispatchQueue.global()) { (data, response) -> Promise <[Any]> in
                switch method {
                case .friendsGet:
                    do {
                        let friends = try JSONDecoder().decode(FriendQuery.self, from: data).response.items
                        return Promise.value(friends)
                    } catch {
                        return Promise { Resolver in Resolver.reject(ParsingError.friendsDecodingFailure) }
                    }
                case .groupsGet:
                    do {
                        let groups = try JSONDecoder().decode(GroupQuery.self, from: data).response.items
                        return Promise.value(groups)
                    } catch {
                        return Promise { Resolver in Resolver.reject(ParsingError.groupsDecodingFailure) }
                    }
                case .photosGet:
                    do {
                        let photos = try JSONDecoder().decode(PhotoQuery.self, from: data).response.items
                        return Promise.value(photos)
                    } catch {
                        return Promise { Resolver in Resolver.reject(ParsingError.photosDecodingFailure) }
                    }
                    //                case .newsFeedGet:
                    //                    do {
                    //                        #if DEBUG
                    //                        print("hello from:\n\(#function)")
                    //                        print(data)
                    //                        #endif
                    //                    } catch {
                    //                        return Promise { Resolver in Resolver.reject(ParsingError.newsFeedDecodingFailure) }
                //                    }
                default:
                    #if DEBUG
                    print("error: in function \(#function) argument \(method.rawValue) is out of range")
                    #endif
                    return Promise { Resolver in Resolver.reject(PromiseError.promiseRejected) }
                }
        }
    }
}


